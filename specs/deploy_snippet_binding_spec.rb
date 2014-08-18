
require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Deploy::SnippetBinding" do
  before(:each) do
    load_config
  end

  it "must create a valid first boot file for chef" do
    host = collection.hosts.get("server.example.org")
    binding = Stork::Deploy::SnippetBinding.new(host)
    first_boot_content = "{\"run_list\":[\"role[base]\",\"recipe[apache]\"]}"
    binding.first_boot_content.must_equal first_boot_content
  end
end