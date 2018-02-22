# This module monkeypatches the Rake release
# part of Bundler::GemHelper to allow more
# complex tag and release messages

def 

Bundler::GemHelper.module_eval do
  def tag_version
    sh %W[git tag -m Version\ #{version} #{version_tag}]
    Bundler.ui.confirm "Tagged #{version_tag}."
    yield if block_given?
  rescue
    Bundler.ui.error "Untagging #{version_tag} due to error."
    sh_with_status %W[git tag -d #{version_tag}]
    raise
  end
end

=begin
Flow goes like this

Check Changelog
Check which is last release
Eat Changelog up to last release
Rebuild docs
Commit
Tag and annotate
Push branch and tags

# This part I'm not sure about the order
Use API to create release
Push RubyGem release

=end