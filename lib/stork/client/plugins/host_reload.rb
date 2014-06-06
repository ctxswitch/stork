module HostReloadPlugin
  class HostReload < Stork::Plugin
    banner "stork host reload (options)"

    def run
      response = RestClient.get "#{stork}/api/v1/reload"
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