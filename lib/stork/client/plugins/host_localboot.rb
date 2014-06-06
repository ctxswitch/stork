module HostLocalbootPlugin
  class HostLocalboot < Stork::Plugin
    banner "stork host localboot HOST (options)"

    def run
      host = args.shift
      raise SyntaxError, "A host must be supplied" if host.nil?
      
      response = RestClient.get "#{stork}/host/#{host}/installed"
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