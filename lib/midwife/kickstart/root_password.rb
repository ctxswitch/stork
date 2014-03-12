module Midwife
  module Kickstart
    class RootPassword < Command
      name 'rootpw'
      option 'iscrypted', boolean: true, default: true, unsets: 'plaintext'
      option 'plaintext', boolean: true, default: false, unsets: 'iscrypted'
      option 'lock', boolean: true, default: true

      # def crypt
      #   unless password
      #     password = random_password
      #   end
      #   salt = rand(36**8).to_s(36)
      #   password.crypt("$6$" + salt)
      # end

      def password
        value || random_password
      end

      def emit
        str = "rootpw"
        unless lock
          str += iscrypted ? " --iscrypted" : " --plaintext"
          str += " " + password
        else
          str += " --lock" 
        end
        str
      end

    # private
    #   def random_password
    #     SecureRandom.urlsafe_base64(40)
    #   end
    end
  end
end