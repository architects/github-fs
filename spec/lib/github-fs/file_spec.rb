require "spec_helper"

describe GHFS::File do
  let(:file) do
    GHFS::File.open("files/existing.txt")
  end

  let(:new_file) { GHFS::File.open("files/new.txt") }

  it "lets me read the contents from a file" do
    expect(file.read).to match("This is some existing content")
  end

  it "lets me know if a file exists" do
    expect(file).to be_exists
  end

  it "lets me know if the file is a new file" do
    expect(new_file).to be_new_file
    expect(new_file).not_to be_exists
  end
end
