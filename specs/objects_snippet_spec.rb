require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Objects::Snippet" do
  it "must create a snippet" do
    file = "./specs/stork/bundles/snippets/noop.erb"
    snippet = Stork::Objects::Snippet.new(file)
    snippet.name.must_equal "noop"
    snippet.content.must_equal "# Default Snippet\n"
  end
end
