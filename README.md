# Stork
[![Build Status](https://travis-ci.org/rlyon/stork.png?branch=master)](https://travis-ci.org/rlyon/stork)
[![Coverage Status](https://coveralls.io/repos/rlyon/stork/badge.png)](https://coveralls.io/r/rlyon/stork)
[![Code Climate](https://codeclimate.com/github/rlyon/stork.png)](https://codeclimate.com/github/rlyon/stork)

Stork is a autoinstall utility, kickstart generation tool and server for CentOS and Redhat systems.  It aims to fill the gap in the bare metal systems deployment that many of the other tools for cloud and virtual systems excel at.

## Installation

Installation using rubygems:

    $ gem install stork

Install the latest version from the github:

    $ git clone https://github.com/rlyon/stork.git

## Usage

### Control the server
    storkctl start restart stop [options]

### Query
    stork host list
    stork host localboot [name]
    stork host install [name]
    stork host show [name]

## Contributing

### Grab the source and make a branch

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Seting up for the kickstart validation tests

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
