module HostListPlugin
  class HostList < Stork::Plugin
    banner "stork host list (options)"

    def run
      data = fetch('hosts')
      data['hosts'].sort.each do |host|
        puts host
      end
    end
  end
end
