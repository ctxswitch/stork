module Stork
  module Resource
    class Password < Base
      attribute :locked, type: :boolean, default: false
      attribute :encrypted, type: :boolean, default: true

      def random_encrypted_password
        salt = rand(36**8).to_s(36)
        random_password.crypt("$6$" + salt)
      end

      def random_password
        SecureRandom.urlsafe_base64(40)
      end

      def value
        random_encrypted_password
      end
    end
  end
end
