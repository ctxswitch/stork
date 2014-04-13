require File.dirname(__FILE__) + '/spec_helper'

describe "Chef" do
  it "should be created" do
    Stork::Objects::Chef.new("test").must_be_instance_of Stork::Objects::Chef
  end

  it "should respond to the name method" do
    Stork::Objects::Chef.new("test").must_respond_to :name
  end

  it "should respond to the url accessors" do
    Stork::Objects::Chef.new("test").must_respond_to :url
    Stork::Objects::Chef.new("test").must_respond_to :url=
  end

  it "should respond to the version accessors" do
    Stork::Objects::Chef.new("test").must_respond_to :version
    Stork::Objects::Chef.new("test").must_respond_to :version=
  end

  it "should respond to the client_key accessors" do
    Stork::Objects::Chef.new("test").must_respond_to :client_key
    Stork::Objects::Chef.new("test").must_respond_to :client_key=
  end

  it "should respond to the client_name accessors" do
    Stork::Objects::Chef.new("test").must_respond_to :client_name
    Stork::Objects::Chef.new("test").must_respond_to :client_name=
  end

  it "should respond to the validator_name accessors" do
    Stork::Objects::Chef.new("test").must_respond_to :validator_name
    Stork::Objects::Chef.new("test").must_respond_to :validator_name=
  end

  it "should respond to the validation_key accessors" do
    Stork::Objects::Chef.new("test").must_respond_to :validation_key
    Stork::Objects::Chef.new("test").must_respond_to :validation_key=
  end

  it "should respond to the encrypted_data_bag_secret accessors" do
    Stork::Objects::Chef.new("test").must_respond_to :encrypted_data_bag_secret
    Stork::Objects::Chef.new("test").must_respond_to :encrypted_data_bag_secret=
  end

  it "should build" do
    ckey = "./specs/keys/snakeoil-root.pem"
    vkey = "./specs/keys/snakeoil-validation.pem"

    chef = Stork::Objects::Chef.build("test") do
      url "https://chef.example.org"
      version "11.4.4"
      client_name "root"
      # Change to read file
      client_key ckey
      validator_name "validator"
      # Change to read file
      validation_key vkey
      encrypted_data_bag_secret "secret"
    end

    chef.name.must_equal "test"
    chef.url.must_equal "https://chef.example.org"
    chef.version.must_equal "11.4.4"
    chef.client_name.must_equal "root"
    chef.client_key.must_equal File.read(ckey)
    chef.validator_name.must_equal "validator"
    chef.validation_key.must_equal File.read(vkey)
    chef.encrypted_data_bag_secret.must_equal "secret"
  end
end
