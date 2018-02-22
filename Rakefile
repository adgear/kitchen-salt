require 'bundler/setup'
require 'bundler/gem_tasks'
require 'git'
require 'mixlib/shellout'
require 'rake'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'
require 'tasks/rake/monkeypatch'
require 'tasks/rake/changelog'

require './tasks/changelog'
require './tasks/concurrency'

Rake::Task.define_task(:environment)

kitchen_concurrency = ENV['KITCHEN_CONCURRENCY'] || 1
kitchen_concurrency = kitchen_concurrency.to_i unless kitchen_concurrency.is_a?(Integer)

clean_suites = %w[
  changelog
  rubocop
  shellcheck
]

desc 'Travis tasks'
namespace :travis do
  desc 'Entrypoint for Travis tasks'
  task :main, [:taskname] => [:environment] do |_task, args|
    if /^integration:/ =~ ENV['SUITE']
      args.with_defaults(taskname: ENV['SUITE'].split(':').last)
      Rake::Task['integration:verify'].invoke(args.taskname)
    else
      Rake::Task[ENV['SUITE']]
    end
  end

  desc 'Cleanup loop for Travis tasks'
  task :cleanup, [:taskname] => [:environment] do |_task, args|
    if /^integration:/ =~ ENV['SUITE']
      args.with_defaults(taskname: ENV['SUITE'].split(':').last)
      Rake::Task['integration:destroy'].invoke(args.taskname)
    end
  end
end

def command_available(command)
  find = Mixlib::ShellOut.new("which #{command}").run_command
  find.run_command
  find.exitstatus.zero? ? true : abort("Unable to find #{command} in PATH, is it installed?")
end

def shellcheck(file)
  shellcheck = Mixlib::ShellOut.new("shellcheck #{file}")
  shellcheck.run_command
  { stdout: shellcheck.stdout, error: shellcheck.error? }
end

desc 'Check bash scripts'
task :shellcheck do |_task, _args|
  # Collect the results from all the shellchecks
  results = []
  Dir.glob('./**/*.sh').each { |file| results << shellcheck(file) } if command_available('shellcheck')

  # This collects all the errors and prints then all instead of stopping at the
  # first file with errors
  unless results.empty?
    acc = { stdout: [], error: false }
    results.each do |result|
      acc[:error] = acc[:error] || result[:error]
      acc[:stdout] << result[:stdout]
    end
    if acc[:error]
      puts acc[:stdout]
      abort
    end
  end
end

desc 'Check the changelog for proper format'
task :changelog do |_task, _args|
  check_changelog('CHANGE.md')
end

desc 'Run Test Kitchen integration tests'
namespace :integration do
  desc 'Run integration tests with kitchen-docker'
  task :verify, [:regexp, :action, :concurrency] do |_t, args|
    args.with_defaults(regexp: 'all', action: 'verify', concurrency: kitchen_concurrency)
    run_kitchen(
      args.action,
      args.regexp,
      args.concurrency.to_i,
      local_config: '.kitchen.docker.yml'
    )
  end

  desc 'destroy instances with kitchen-docker'
  task :destroy, [:taskname] => [:environment] do |_task, args|
    args.with_defaults(taskname: 'all')
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.docker.yml')
    Kitchen::Config.new(loader: @loader).instances.each do |instance|
      instance.destroy if (args.taskname == 'all') || instance.name.include?(args.taskname)
    end
  end

  desc 'default task'
  task :test, [:taskname] => [:environment] do |_task, args|
    args.with_defaults(taskname: 'all')
    clean_suites.each { |task| Rake::Task[task] }
    Rake::Task['integration:verify'].invoke(args.taskname)
    Rake::Task['integration:destroy'].invoke(args.taskname)
  end
end

desc 'Run yarddoc for the source'
YARD::Rake::YardocTask.new

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = %w[
    --config .rubocop.yml
    --display-cop-names
    --extra-details
    --display-style-guide
  ]
end

task default: ['integration:test']
