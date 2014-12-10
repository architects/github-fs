require "spec_helper"

describe GHFS do
  it "should have access to the github api" do
    expect(GHFS.api.user.login).not_to be_nil
  end
end
