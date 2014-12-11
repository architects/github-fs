module GHFS
  module Util
    def self.use_temporary_branch
      GHFS.config.branch = temporary_branch
      create_branch(temporary_branch)
    end

    def self.remove_temporary_branch
      if temporary_branch_exists?
        remove_branch(temporary_branch)
      end
    end

    def self.temporary_branch_exists?
      !@temporary_branch.nil?
    end

    def self.temporary_branch
      @temporary_branch ||= "temp-branch-#{ rand(36**36).to_s(36).slice(0,8) }"
    end

    def self.create_branch(name, repo=nil)
      if repo ||= GHFS.config.repository
        master_branch = GHFS.api.branch(repo, "master")
        master_sha = master_branch.commit.sha
        refs = GHFS.api.create_ref(repo, "heads/#{ name }", master_sha)

        ref = Array(refs).flatten.last
        ref && ref.commit && ref.commit.sha
      end
    end

    def self.remove_branch(name, repo=nil)
      if repo ||= GHFS.config.repository
        names = GHFS.api.branches(repo).map(&:name)

        if names.any? {|n| n == name }
          GHFS.api.delete_branch(repo, name)
        end
      end
    end
  end
end
