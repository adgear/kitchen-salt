require 'git'
require 'semver'

def get_branch(folder)
  repo = Git.open(folder)
  Git::Branch.name
end

def last_released?(folder)
  repo = Git.open(folder)

end

def check_changelog(file)
  data = File.read(file).split("\n")
  line = behead(data.first.strip)

  line =~ SEMVER_REGEX
end

class Title
  def initialize(string)
    @raw = string
  end

  # remove the header
  def behead(line) do
    line.gsub!('## ', nil)
  end

  # remove the v
  def bevee(line)
    line.gsub('v', nil)
  end

  def valid?(line)
    case line
    when /(major|minor|patch|alpha)/
      true
    when -> (l) { Mixlib::Versioning.parse(l.gsub('v', nil)) }
      true
    else
      false
    end
  end
end
