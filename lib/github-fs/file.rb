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
      @branch     = options.fetch(:branch, nil)
    end

    def read
      @contents ||= begin
                      encoded = api_entity.content rescue nil

                      if encoded.to_s.length > 0
                        Base64.decode64(encoded)
                      end
                    end
    end

    def puts(contents)
    end

    def write(contents)
    end

    def api_entity
      @api_entity ||= GHFS.api.contents(repository, path: path, ref: ref)
    rescue Octokit::NotFound
      @new_file = true
    rescue
      nil
    end

    def new_file?
      api_entity unless @api_entity
      !@new_file.nil?
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

    def ref
      options.fetch(:ref) do
        branch || options[:commit] || options[:tag] || "master"
      end
    end
  end
end
