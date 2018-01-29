require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'
require 'yard'

Rake::Task.define_task(:environment)

clean_suites = %w(
  changelog
  rubocop
  shellcheck
)

desc 'Travis tasks'
namespace :travis do
  desc 'Entrypoint for Travis tasks'
  task :main, [:taskname] => [:environment] do |_task, args|
    if /^integration:/.match ENV['SUITE']
      args.with_defaults(taskname: ENV['SUITE'].split(':').last)
      Rake::Task['integration:verify'].invoke(args.taskname)
    else
      Rake::Task[ENV['SUITE']]
    end
  end

  desc 'Cleanup loop for Travis tasks'
  task :cleanup, [:taskname] => [:environment] do |_task, args|
    if /^integration:/.match ENV['SUITE']
      args.with_defaults(taskname: ENV['SUITE'].split(':').last)
      Rake::Task['integration:destroy'].invoke(args.taskname)
    end
  end
end

desc 'Check bash scripts'
namespace :shellcheck do
  desc 'Check bash scripts'
  task :main, [:taskname] => [:environment] do |_task, args|
  end
end

desc 'Run Test Kitchen integration tests'
namespace :integration do

  # All of the concurrency code is lifted from
  # https://github.com/zuazo/kitchen-in-travis/blob/master/Rakefile.concurrency

  # Gets a collection of instances.
  #
  # @param regexp [String] regular expression to match against instance names.
  # @param config [Hash] configuration values for the `Kitchen::Config` class.
  # @return [Collection<Instance>] all instances.
  def kitchen_instances(regexp, config)
    instances = Kitchen::Config.new(config).instances
    instances = instances.get_all(Regexp.new(regexp)) unless regexp.nil? || regexp == 'all'
    raise Kitchen::UserError, "regexp '#{regexp}' matched 0 instances" if instances.empty?
    instances
  end

  # Runs a test kitchen action against some instances.
  #
  # @param action [String] kitchen action to run (defaults to `'test'`).
  # @param regexp [String] regular expression to match against instance names.
  # @param concurrency [#to_i] number of instances to run the action against concurrently.
  # @param loader_config [Hash] loader configuration options.
  # @return void
  def run_kitchen(action, regexp, concurrency, loader_config = {})
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    config = { loader: Kitchen::Loader::YAML.new(loader_config) }

    call_threaded(
      kitchen_instances(regexp, config),
      action,
      concurrency
    )
  end

  # Calls a method on a list of objects in concurrent threads.
  #
  # @param objects [Array] list of objects.
  # @param method_name [#to_s] method to call on the objects.
  # @param concurrency [Integer] number of objects to call the method on concurrently.
  # @return void
  def call_threaded(objects, method_name, concurrency)
    puts "method_name: #{method_name}, concurrency: #{concurrency}"
    threads = []
    raise 'concurrency must be > 0' if concurrency < 1
    objects.each do |obj|
      sleep 3 until threads.map(&:alive?).count(true) < concurrency
      threads << Thread.new { obj.method(method_name).call }
    end
    threads.map(&:join)
  end

  desc 'Run integration tests with kitchen-docker'
  task :verify, [:regexp, :action, :concurrency] do |_t, args|
    args.with_defaults(regexp: 'all', action: 'verify', concurrency: 4)
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
      if (args.taskname == 'all') || instance.name.include?(args.taskname)
        instance.destroy
      end
    end
  end

  desc 'default task'
  task :test, [:taskname] => [:environment] do |_task, args|
    args.with_defaults(taskname: 'all')
    clean_suites.each do |task|
      Rake::Task["#{task}:main"]
    end
    Rake::Task['integration:verify'].invoke(args.taskname)
    Rake::Task['integration:destroy'].invoke(args.taskname)
  end
end

desc 'Run yarddoc for the source'
YARD::Rake::YardocTask.new

task default: ['integration:test']
