module HostActionsPlugin
  class HostActions < Stork::Plugin
    banner "stork host actions (options)"

    def run
      data = fetch('actions')
      data['hosts'].each do |host|
        print(host['name'], host['action'].upcase, pad: 32)
      end
    end
  end
end