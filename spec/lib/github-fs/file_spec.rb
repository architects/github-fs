require "spec_helper"

describe GHFS::File do
  let(:file) do
    GHFS::File.open("files/existing.txt")
  end

  it "lets me read the contents from a file" do
    expect(file.read).to match("This is some existing content")
  end
end
