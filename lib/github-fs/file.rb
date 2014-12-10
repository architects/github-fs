module GHFS
  class File
    class << self
      def open(path, mode=nil, options={}, &block)
        file = new(path, mode, options)
        yield(file) if block_given?
        file
      end
    end

    attr_reader :path, :mode, :options

    def initialize(path, mode="w", options={})
      @path = path
      @mode = mode || "w"
      @options = options
    end

    def read
      @contents ||= begin
                      encoded = GHFS.api.contents(GHFS.config.repository, path: path).content rescue nil

                      if encoded.to_s.length > 0
                        Base64.decode64(encoded)
                      end
                    end
    end
  end
end
