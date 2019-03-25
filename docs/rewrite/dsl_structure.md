# DSL Structure

Structure of the DSL in comparison with the kickstart and preseed counterparts.  I think we need to approach this as more like a machine and os DSL rather than tying it to kickstart like I did previously.

The universal structure that will be used for communication between client and server will be json based.

Moving away from templates.  I only rarely used them and the fact that we can have one nost block used for multiple servers makes them less appealing.  In the new version I think that the other configuration management and post/pre scripts should be highlighted.  The kickstart/preseed should be very minimal and only take care of the things that configuration management tools are not very good at.  Setting up network interfaces, partitions and disks.  This simplifies the structure and makes it easier to manage.

Should we have special blocks for ansible/

# Host Block

```ruby
host 'rhel.example.org' do
  # Kickstart vs. preseed
  family :rhel # :rhel, :debian

  # Provisioner will be run as a postinstall script and run after snippets
  # :ansible, :chef, :puppet, :salt, :archive, :shell, :none
  provisioner :chef
  provisioner_artifact_url 'http://my.artifact.server/artifact.tar.gz'

  disks do
    ...
  end

  network do
    ...
  end

  # Do we even want snippets?
  snippets do
    pre_install 'pre1', 'pre2' # Mostly unused
    post_install 'post1', 'post2' # Mostly unused, but run before provisioners
  end
end
```

# Package Block

Being removed in favor of snippets and config management support.

# Volume Block

```ruby
disks 'sda', 'sdb' do
  clear true # Clears all partitions all disks and zeros the mbr

  partition '/boot' do
    ondisk 'sda'
    size 100
    format 'ext4'
    options 'noatime', 'nodiratime'
  end

  partition 'swap' do
    ondisk 'sda'
    size 4096
  end

  partition 'pv.01' do
    ondisk 'sda', 'sdb'
    lvm
    grow
  end

  volume_group 'vg.01', part: 'pv.01' do
    logvol '/var', name: 'lv.var', format: 'ext4', size: 4096, options: 'foo'
    logvol '/tmp', name: 'lv.tmp', format: 'ext4', size: 1024
    logvol '/', name: 'lv.root', format: 'ext4', grow
  end
end
```

# Network Block

Unlike previous versions, the pxeboot mac address will be assigned to the host when it is created on the server and not managed in config.  Just a thought though... it may be nice to be able to import and export the host setup and state lists from the server.

```ruby
network do
  noipv6

  # Bonded interface
  interface 'bond0' do
    # Standard interface setup that is available to all types
    ip :static, address: '10.0.0.10', netmask: '255.255.255.0', gw: '10.0.0.1'
    nameservers '1.2.3.4', '1.2.3.5'
    onboot true
    mtu 1600
    
    # If bonding block is present the interface becomes bonded, interfaces listed
    # become configured as the bond slaves.
    bonding 'em1', 'em2' do
      mode 4
      miimon 100
      lacp_rate 1
    end

    # Standard routing that is avalable to all
    route :add, network: '10.1.1.0', mask: '255.255.255.0', gw: '10.1.1.1'
    route :add, network: '10.1.2.0', mask: '255.255.255.0', gw: '10.1.2.1'
    end
  end

  # Static interface block
  interface 'em1' do
    ip :static, address: '10.0.0.10', netmask: '255.255.255.0', gw: '10.0.0.1'
    nameservers '1.2.3.4', '1.2.3.5'
    onboot true
    mtu 1600
  end

  # Dynamic interface block
  interface 'em2' do
    ip :dhcp
    nameservers '1.2.3.4', '1.2.3.5'
    onboot true
    mtu 1600
  end

  # Possibly accept this for static and dynamic simple interfaces?
  interface 'em1', address: '10.0.0.10', netmask: '255.255.255.0', gw: '10.0.0.1'
  interface 'em2'
end
```
