require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Snippet" do
  it "must create a snippet" do
    file = File.dirname(__FILE__) + '/files/configs/snippets/default.erb'
    snippet = Midwife::DSL::Snippet.new(file)
    snippet.name.must_equal "default"
    snippet.content.must_equal "# Default Snippet\n"
  end
end
