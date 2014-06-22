# Stork
[![Build Status](https://travis-ci.org/rlyon/stork.png?branch=master)](https://travis-ci.org/rlyon/stork)
[![Coverage Status](https://coveralls.io/repos/rlyon/stork/badge.png)](https://coveralls.io/r/rlyon/stork)
[![Code Climate](https://codeclimate.com/github/rlyon/stork.png)](https://codeclimate.com/github/rlyon/stork)

Stork is a autoinstall utility, kickstart generation tool and server for CentOS and Redhat systems.  It aims to fill the gap in the bare metal systems deployment that many of the other tools for cloud and virtual systems excel at.

### ***Currently under heavy development***

## Installation

Installation using rubygems:

    $ gem install stork --pre

Install the latest version from the github:

    $ git clone https://github.com/rlyon/stork.git

## Usage

### Control the server
    storkctl start restart stop [options]

### Commands
    stork host install [name]
    stork host list
    stork host localboot [name]
    stork host reload
    stork host show [name]

## Resources

### Host Resource

* ```layout``` - Disk layout containing partition and volume group information (see 'Layout Resource').  You can supply a string or a block value.  If a string is supplied stork will attempt to find the id matching a previously defined layout.
* ```template``` - The kickstart template to use when generating the autoinstallation instructions
* ```chef``` - Chef server information (see 'Chef Resource').  You can supply a string or a block value.  If a string is supplied stork will attempt to find the id matching a previously defined chef server.
* ```pxemac``` - The mac address of the PXE enabled interface.  Used to create the boot configuration files.
* ```pre_snippet``` - Scripts that will be run in the **pre** section before the install begins.  Snippets are accessed by the basename of the file they are stored in.
* ```post_snippet``` - Scripts that will be run in the **post** section afer the install has successfully completed.  Snippets are accessed by the basename of the file they are stored in.
* ```interface``` - Network interface information (see 'Interface Resource'). Takes only a block value.
* ```distro``` - Distribution information (see 'Distro Resource').  You can supply a string or a block value.  If a string is supplied stork will attempt to find the id matching a previously defined distribution.
* ```timezone``` - The IANA zone name (e.g. 'America/Chicago') 
* ```firewall``` - Initial firewall settings (see firewall resource).  Block only.
* ```selinux``` - String or symbol value representing the three selinux states. The only valid values are:  enforcing, permissive, or disabled.  Default is enforcing
* ```package``` - Adds a package to the install.  Generally not needed as the minimal set of packages that are installed by default will be enough to install the configuration management software.
* ```run_list``` - Chef runlist items that will populate the first-boot.json file.  Can be an array or string value
* ```repos``` - Add a new repo to the host (see Repo Resource)
* ```stork``` - Url.  Override the stork server location.

Typical hosts will look like:

```ruby
host "server.example.org" do
  template    "default"
  chef        "default"
  pxemac      "00:11:22:33:44:55"
  layout      "home"
  distro      "centos"
  repo        "whamcloud-client", baseurl: "http://yum.example.com/eln/x86_64"
  package     "foo"


  interface "eth0" do
    bootproto :static
    ip        "99.99.1.8"
    network   "org"
  end

  interface "eth1" do
    bootproto :static
    ip        "192.168.1.10"
    netmask   "255.255.255.0"
    gateway   "192.168.1.1"
    nameserver "192.168.1.253"
    nameserver "192.168.1.252"
  end

  pre_snippet    "setup"
  post_snippet   "ntp"
  post_snippet   "resolv-conf"
  post_snippet   "chef-bootstrap"
  post_snippet   "chef-reconfigure"
  post_snippet   "notify"

  run_list %w{ role[base] recipe[apache] }
end
```

Or define hosts programatically with ruby iterators:

```ruby
hosts=[
  [10, "00:11:22:33:44:01"],
  [11, "00:11:22:33:44:02"],
  [12, "00:11:22:33:44:03"],
  [13, "00:11:22:33:44:04"],
  [14, "00:11:22:33:44:05"],
  [15, "00:11:22:33:44:06"],
  [16, "00:11:22:33:44:07"],
  [17, "00:11:22:33:44:08"],
  [18, "00:11:22:33:44:09"],
  [19, "00:11:22:33:44:10"]
]

hosts.each do |octet, mac|
  host "c0#{octet}.example.org" do
    template    "default"
    chef        "default"
    distro      "centos"
    pxemac      mac
    layout      "home"


    interface "eth0" do
      bootproto :static
      ip        "192.168.10.#{octet}"
      network   "org"
    end
    run_list %w{ role[node] }
  end
end
```

### Layout Resource

* ```zerombr``` - Initialize invalid partition tables
* ```clearpart``` - Remove partitions prior to the creation of new partitions
* ```partition``` or ```part``` - Partition information (see Partition Resource).
* ```volume_group``` or ```vg``` - Volume group information (see Volume Group Resource)

Layouts can be defined seperately from hosts and referenced in hosts by name.  A typical layout will look like this:

```ruby
layout "root_and_home" do
  clearpart
  zerombr
  part "/boot" do
    size 100
    type "ext4"
    primary
  end

  part "swap" do
    recommended
    type "swap"
    primary
  end

  part "/" do
    size 4096
    type "ext4"
  end

  part "pv.01" do
    size 1
    grow
  end

  volume_group "vg", part: "pv.01" do
    logical_volume "lv_home" do
      path "/home"
      size 1
      grow
    end
  end
end
``` 

When used inline with a host block, the layout is not stored and cannot be referenced from other hosts.

### Partition Resource

* ```size``` - Size of the partition in MB.
* ```type``` - Set the file system type.
* ```primary``` - Force allocation of the partition as a primary partition.
* ```grow``` - Grow the partition to the maximum amount.
* ```recommended``` - Let the installer determine the recommended size.

See ```layout``` for an example of how partition can be used to define disk partitions. 

### Volume Group Resource

* ```logical_volume``` - Add a logical volume to the volume group.

See ```layout``` for an example of how volume_group can be used to define volume groups.

### Logical Volume Resource

#### ```logical_volume``` or ```logvol```  

* ```path``` - Mount point.
* ```size``` - Size of the logical volume in MB.
* ```type``` - Set the file system type.
* ```grow``` - Grow the logical volume to the maximum amount.
* ```recommended``` - Let the installer determine the recommended size.

See ```layout``` for an example of how logical_volume can be used to define logical volumes.

### Distro Resource

* ```kernel``` - Name of the kernel.  This is the kernel that will be transfered via tftp to the host at install time.
* ```image``` - Name of the RAM disk image of the installer.
* ```url``` - Install url for network install (only supports http - at least thats the only one I'm testing with)

```ruby
distro "centos" do
  kernel "vmlinuz"
  image "initrd.img"
  url "http://mirror.example.com/centos"
end
```

### Firewall Resource

TODO

### Interface Resource

TODO

### Network Resource

TODO

### Chef Resource

* ```version``` - The version of chef to use.
* ```client_name``` - The admin client name.
* ```client_key``` - The admin client key file.
* ```validator_name``` - The validation client name.
* ```validation_key``` - The validation key file.
* ```encrypted_data_bag_secret``` - A string value of the data bag encryption key.

```ruby
chef "default" do
  url "https://chef.example.org"
  version "11.6.0"
  client_name "root"
  client_key "./specs/keys/snakeoil-root.pem"
  validator_name "chef-validator"
  validation_key "./specs/keys/snakeoil-validation.pem"
  encrypted_data_bag_secret "9EE8rGyPB8mXARNrzSDal9TOAQ...e7/x2uPkqMS/tOU="
end
```

## Templates and Snippet Scripts

Templates and snippets use the ERB templating system.  When the ERB files are rendered, binding are created to expose ruby the underlying ruby objects.  

In kickstart templates, the generated kickstart commands can be accessed:

* ```url``` - Outputs the kickstart command assigning the URL for network installs.
* ```network``` - Outputs each interface kickstart command for all defined interfaces.
* ```password``` - Outputs the 'rootpw' command with a randomized password.
* ```firewall``` - Outputs the firewall command.
* ```timezone``` - Outputs the timezone command for the installer.
* ```selinux``` - Outputs the selinux command.
* ```layout``` - Outputs all of the partition, volume groups and logical volume commands.
* ```bootloader``` - Outputs the bootloader config information.
* ```zerombr``` - Outputs the zerombr command.
* ```clearpart``` - Outputs the clearpart command.
* ```repos``` - Outputs all additional repo commands.
* ```packages``` - Outputs the packages section.
* ```pre_snippets``` - Renders and outputs all pre snippets in the %pre section.
* ```post_snippets``` - Renders and outputs all post snippets in the %post section.

In addition to the kickstart command generators, the following objects are exposed and can be used:

* ```host``` - The complete host object for the current host.

Snippets expose the following objects to the template:

* ```host``` - The current host.
* ```chef``` - The chef object.
* ```authorized_keys``` - A string containing all the public keys.
* ```first_boot_content``` - A string representation of the json content that will make up the first_boot file.
* ```nameservers``` - An array of all unique nameservers.
* ```search_paths``` - An array of all unique search_paths.
* ```stork_server``` - The IP address or hostname of the stork server.
* ```stork_port``` - The port that the stork server is running on.
* ```stork_bind``` - The bind IP address of the stork server.


## Contributing

### Grab the source and make a branch

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Setting up for the kickstart validation tests

To run the kickstart validation tests on your local system, you
will need to install python and the python virtualenv module.  
I'm currently using 2.7, and I don't know if it makes a difference.  
On Linux you can use your favorite package manager if by some chance 
your distribution didn't come with it installed.  On Mac use homebrew 
or macports to avoid using the system python which is bound to be 
a very old version.

    $ brew install python
    $ pip install virtualenv

Once python and virtualenv has been installed, run

    $ rake validator:setup

This will create the directories that you need, set up a virtual
environment and get everything ready for the integration tests.

### Run the tests to see if it breaks

    $ rake test
