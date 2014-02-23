require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Build::Chef" do
  it "emits the bootstrap" do
    bootstrap = Midwife::Build::Chef.build 'test' do
      url "https://chef.example.org"
      version "11.6.0"
      client_name "root"
      client_key "specs/files/snakeoil-root.pem"
      validator_name "chef-validator"
      validation_key "specs/files/snakeoil-validation.pem"
      encrypted_data_bag_secret "secretkey"
    end
    hostname = "coolsystem.private"
    run_list = ['role[one]', 'recipe[two]']
    output = bootstrap.emit(hostname, run_list)
    output.must_equal File.read("specs/files/results/chef-bootstrap.sh")
  end
end