require 'github-fs'
require 'pry'


RSpec.configure do |config|
  config.mock_with :rspec
  config.order = :random

  config.before(:suite) do
    cfg = YAML.load(IO.read(File.dirname(__FILE__) + "/credentials.yml"))

    GHFS::Config.repository = cfg[:repository] || cfg["repository"]
    GHFS::Config.github_access_token = cfg[:github_access_token] || cfg["github_access_token"]
  end
end
