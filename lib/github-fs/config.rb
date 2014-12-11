module GHFS
  class Config
    include Singleton

    def self.method_missing(meth, *args, &block)
      if instance.respond_to?(meth)
        instance.send(meth, *args, &block)
      else
        super
      end
    end

    def branch= value
      @branch = value
    end

    def branch
      @branch || "master"
    end

    def github_access_token= value
      @github_access_token = value
    end

    def github_access_token
      @github_access_token || raise("Github access token is not set")
    end

    def repository= value
      @repository = value
    end

    def repository
      @repository || raise("Github repository is not set")
    end

  end
end
