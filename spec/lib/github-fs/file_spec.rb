require "spec_helper"

describe GHFS::File do
  let(:file) do
    GHFS::File.open("files/existing.txt")
  end

  let(:new_file) { GHFS::File.open("files/new.txt") }

  describe "File Modes" do
    it "knows if it should create a file that doesnt exist" do
      %w(w+ a+).each do |mode|
        file = GHFS::File.open("modes.txt", mode)
        expect(file).to be_should_create
      end
    end

    it "has modes which will not create new files" do
      %w(w a).each do |mode|
        file = GHFS::File.open("modes.txt", mode)
        expect(file).not_to be_should_create
      end
    end

    it "has append modes" do
      file = GHFS::File.open("modes.txt", "a+")
      expect(file).to be_append
    end

    it "has writable modes" do
      %w(w a w+ a+).each do |mode|
        file = GHFS::File.open("modes.txt", mode)
        expect(file).to be_writable
        expect(file).not_to be_read_only
      end
    end

    it "has read only modes" do
      file = GHFS::File.open("modes.txt", "r")
      expect(file).not_to be_writable
      expect(file).to be_read_only
    end
  end

  describe "Flags" do
    it "lets me know if a file exists" do
      expect(file).to be_exists
    end

    it "lets me know if the file is a new file" do
      expect(new_file).to be_new_file
      expect(new_file).not_to be_exists
    end
  end

  describe "Reading" do
    it "lets me read the contents from a file" do
      expect(file.read).to match("This is some existing content")
    end
  end

  describe "Writing" do
    it "fails if i attempt to perform an operation on a missing file and do not specify a create flag" do
      expect(lambda do
        GHFS::File.open("missing.txt", "a") do |fh|
          fh.write("shit")
        end
      end).to raise_error(GHFS::NotFound)
    end

    it "lets me append to an existing file" do
      GHFS::File.open("append-existing.txt", "w+") do |fh|
        fh.write("begin")
      end

      file = GHFS::File.open("append-existing.txt", "a") do |fh|
        fh.write("end")
      end

      content = file.read

      expect(content).to include("begin")
      expect(content).to include("end")
    end

    it "lets me append to or create a file" do
      needle = rand(36**36).to_s(36)

      expect(lambda do
        GHFS::File.open("append-create.txt", "a+") do |fh|
          fh.write("appending #{ needle }")
        end
      end).not_to raise_error

      file = GHFS::File.open("append-create.txt","r")
      expect(file.read).to include(needle)
    end

    it "lets me modify the contents of a file" do
      content = file.read
      needle = rand(36**36).to_s(36)
      file.write("#{ content }\n#{ needle }")

      modified = GHFS::File.open("files/existing.txt")
      expect(modified.read).to match(content)
      expect(modified.read).to match(needle)
    end

    it "lets me modify the contents of or create a file" do
      brand_new = GHFS::File.open("files/brand-spanking-new.txt","w+") do |fh|
        fh.write("this is some brand new stuff")
      end

      expect(brand_new).not_to be_new_file
      expect(brand_new).to be_exists
      expect(brand_new.latest_sha).not_to be_nil
    end
  end

end
