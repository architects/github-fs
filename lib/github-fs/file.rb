module GHFS
  class File
    class << self
      def open(path, mode=nil, options={}, &block)
        file = new(path, mode, options)
        yield(file) if block_given?
        file
      end
    end

    attr_reader :path, :mode, :options, :repository, :branch

    def initialize(path, mode="w", options={})
      @path       = path
      @mode       = mode || "w"
      @options    = options
      @repository = options.fetch(:repository) { GHFS.config.repository }
      @branch     = options.fetch(:branch) { GHFS.config.branch }
      @contents   = options[:contents] || options[:content]
    end

    def contents
      @contents || read
    end

    def read
      @contents ||= begin
                      encoded = api_entity.content rescue nil

                      if encoded.to_s.length > 0
                        Base64.decode64(encoded)
                      end
                    end
    end

    def delete
      raise GHFS::NotFound if new_file?
      raise GHFS::ReadOnly if read_only?
      GHFS.api.delete_contents(repo, path, "Deleting #{ path }", branch: branch)
    end

    def unlink
      delete
    end

    def write(contents)
      read

      if append?
        @contents = @contents.to_s
        @contents += contents
      else
        @contents = contents
      end

      @contents
    ensure
      with_contents_persisted
      @contents
    end

    def puts(contents)
      contents = "#{ contents }\n" unless contents.to_s.match(/\n$/m)
      write(contents)
    end

    def api_entity
      @api_entity ||= GHFS.api.contents(repository, path: path, ref: ref)
    rescue Octokit::NotFound
      @new_file = true
    rescue
      nil
    end

    def with_contents_persisted
      case
      when read_only?
        raise GHFS::ReadOnly
      when !should_create? && new_file?
        raise GHFS::NotFound
      when new_file? && should_create?
        @new_file = nil
        message = "Creating #{ path }"
        GHFS.api.create_contents(repository, path, message, encoded_contents, branch: branch)
      when !new_file?
        @new_file = nil
        message = "Updating #{ path }"
        GHFS.api.update_contents(repository, path, message, latest_sha, encoded_contents, branch: branch)
      end
    end

    def encoded_contents
      # the octokit gem handles encoding for us
      contents.to_s
    end

    def new_file?
      api_entity unless @api_entity
      !@new_file.nil?
    end

    def latest_sha
      !new_file? && api_entity && api_entity.sha
    end

    def exists?
      !new_file?
    end

    def read_only?
      mode == "r"
    end

    def append?
      mode == "a" || mode == "a+"
    end

    def writable?
      append? || mode == "w" || mode == "w+"
    end

    def should_create?
      mode == "w+" || mode == "a+"
    end

    def ref
      options.fetch(:ref) do
        branch || options[:commit] || options[:tag] || "master"
      end
    end
  end
end
