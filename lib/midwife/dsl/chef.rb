module Midwife
  module DSL
    class Chef
      include Base
      string :version
      string :url
      string :client_name
      file :client_key
      string :run_list
      string :validator_name
      file :validation_key
      string :encrypted_data_bag_secret
    end
  end
end
