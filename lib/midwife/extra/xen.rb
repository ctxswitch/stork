module Midwife
  class Xentools
    def initialize(config)
      @config = config
      @host = config.host
      @template = config.template
      @xen = @host['xen']
      @path = config.path
    end

    def vminstall
      xsb = Midwife::XentoolsBindings.new(@config)
      command = ERB.new(vm_create_erb).result(xsb.get_binding)
      ssh = Midwife::SSH.new(@xen['host'])
      ssh.run(command)
    end

    def vm_create_erb
      erb = <<-eos
bash -c '
notice () {
  echo " * $@"
}

step () {
  echo "   - $@"
}

error () {
  echo " !!! $@"
}

countdown () {
  echo -n " *** Waiting $1 seconds:"
  for i  in `seq $1 1` ; do
    echo -n " $i"
    sleep 1
  done
  echo
}
notice "Creating the VM guest on `uname -n`"
step "Getting the template uuid for CentOS 6"
# Can only use the centos 6 template right now.
TMPLUUID=`xe template-list | grep -B1 "name-label.*CentOS.* 6.*64-bit" | awk -F\':\' \'/uuid/{print $2}\' | tr -d " "`
step "Using template id: $TMPLUUID"
step "Configuring <%= host %>."
VMUUID=`xe vm-install new-name-label=<%= host %> template=\$TMPLUUID`

# Setting up network interfaces
<% networks.each do |network| %>
step "Setting up network on <%= network['network'] %>"
NETUUID=`xe network-list name-label=<%= network['network'] %> --minimal`
xe vif-create vm-uuid=$VMUUID network-uuid=$NETUUID mac=<%= network['mac'] %> device=<%= network['device'] %>
<% end %>

# Setting up the parameters
xe vm-param-set uuid=$VMUUID other-config:install-repository=<%= config.os_web %>
step "Setting kickstart boot parameters"
xe vm-param-set uuid=$VMUUID PV-args=\"ks=<%= config.kickstart_web %> ksdevice=bootif\"

step "Setting memory constraints"
xe vm-memory-limits-set uuid=$VMUUID static-min=<%= memory %> dynamic-min=<%= memory %> dynamic-max=<%= memory %> static-max=<%= memory %>

step "Setting CPU constraints"
xe vm-param-set platform:cores-per-socket=<%= cores %> uuid=$VMUUID
xe vm-param-set VCPUs-max=<%= cpus %> uuid=$VMUUID
xe vm-param-set VCPUs-at-startup=<%= cpus %> uuid=$VMUUID

step "Starting VM"
xe vm-start uuid=$VMUUID
notice "Finished.  Use xe-console to connect to the guest."
'
      eos
    end
  end

  class XentoolsBindings
    def initialize(config)
      @template = config.template
      @host = config.host
      @xen = @host['xen']
      @config = config
    end

    def get_binding
      host = @host['id']
      os = @host['os']
      networks = @xen['networks']
      cores = @xen['cores']
      cpus = @xen['cpus']
      memory = @xen['memory'].to_i * 1024 * 1024 * 1024
      config = @config
      binding
    end
  end
end