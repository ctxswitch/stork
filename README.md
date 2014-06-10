# Stork
[![Build Status](https://travis-ci.org/rlyon/stork.png?branch=master)](https://travis-ci.org/rlyon/stork)
[![Coverage Status](https://coveralls.io/repos/rlyon/stork/badge.png)](https://coveralls.io/r/rlyon/stork)
[![Code Climate](https://codeclimate.com/github/rlyon/stork.png)](https://codeclimate.com/github/rlyon/stork)

Stork is a autoinstall utility, kickstart generation tool and server for CentOS and Redhat systems.  It aims to fill the gap in the bare metal systems deployment that many of the other tools for cloud and virtual systems excel at.

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

* ```layout``` - Partitioning information (see 'Layout Resource').  You can supply a string or a block value.  If a string is supplied stork will attempt to find the id matching a previously defined layout.
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

Or define hosts programatically with ruby iterators:

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

### Layout Resource

TODO

### Partition Resource

TODO

### Volume Group Resource

TODO

### Logical Volume Resource

TODO

### Distro Resource

TODO

### Firewall Resource

TODO

### Interface Resource

TODO

### Network Resource

TODO


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
