require 'pathname'
require 'singleton'
require 'yaml'
require 'octokit'
require 'github-fs/version'
require 'github-fs/util'
require 'github-fs/test_helpers'
require 'github-fs/config'
require 'github-fs/file'
require 'github-fs/dir'

module GHFS
  NotFound = Class.new(Exception)
  ReadOnly = Class.new(Exception)

  def self.config
    GHFS::Config.instance
  end

  def self.api
    @api ||= Octokit::Client.new(access_token: config.github_access_token)
  end
end
