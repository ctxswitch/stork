module Midwife
  module DSL
    class Password
      attr_reader :value
      attr_accessor :locked
      attr_accessor :encrypted
      attr_accessor :plaintext

      def initialize
        @value = random_encrypted_password
        @locked = false
        @encrypted = true
        @plaintext = false
      end

      def locked?
        locked
      end

      def to_s
        value
      end

      def random_encrypted_password
        salt = rand(36**8).to_s(36)
        random_password.crypt("$6$" + salt)
      end

      def random_password
        SecureRandom.urlsafe_base64(40)
      end

      def self.build(&block)
        pw = new
        delegator = PasswordDelegator.new(pw)
        delegator.instance_eval(&block)
        pw
      end

      class PasswordDelegator
        def initialize(obj)
          @delegated = obj
        end

        def lock
          @delegated.locked = true
        end

        def encrypted(value)
          @delegated.plaintext = false
          @delegated.encrypted = true
          @delgated.value = value
        end

        def plaintext(value)
          @delegated.encrypted = false
          @delegated.plaintext = true
          @delgated.value = value
        end
      end
    end
  end
end
