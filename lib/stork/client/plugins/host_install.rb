module HostInstallPlugin
  class HostInstall < Stork::Plugin
    banner "stork host install HOST (options)"

    def run
      host = args.shift
      raise SyntaxError, "A host must be supplied" if host.nil?
      
      response = RestClient.get "#{stork}/host/#{host}/install"
      if response.code == 200
        puts "OK"
      else
        data = JSON.parse(response)
        puts "Error: #{data['message']}"
        exit 1
      end
    end
  end
end