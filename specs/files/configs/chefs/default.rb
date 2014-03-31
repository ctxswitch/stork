chef "default" do
  url "https://chef.example.org"
  version "11.6.0"
  client_name "root"
  client_key File.dirname(__FILE__) + "/specs/files/configs/keys/snakeoil-root.pem"
  validator_name "chef-validator"
  validation_key File.dirname(__FILE__) + "/specs/files/configs/keys/snakeoil-validation.pem"
  encrypted_data_bag_secret "secretkey"
end
