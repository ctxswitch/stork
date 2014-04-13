chef "default" do
  url "https://chef.example.org"
  version "11.6.0"
  client_name "root"
  client_key "./specs/keys/snakeoil-root.pem"
  validator_name "chef-validator"
  validation_key "./specs/keys/snakeoil-validation.pem"
  encrypted_data_bag_secret "secretkey"
end
