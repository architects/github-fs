require "spec_helper"

describe GHFS::Config do
  it "requires a github access token" do
    expect(GHFS.config.github_access_token).not_to be_nil
  end
end
