# Midwife
[![Build Status](https://travis-ci.org/rlyon/midwife.png?branch=master)](https://travis-ci.org/rlyon/midwife)
[![Coverage Status](https://coveralls.io/repos/rlyon/midwife/badge.png)](https://coveralls.io/r/rlyon/midwife)

Midwife is a kickstart generation tool and server for CentOS and Redhat systems.  
It aims to fill the gap in the deployment of bare metal systems that current tools
provide.

## Installation

Installation using rubygems:

    $ gem install midwife

Install the latest version from the github:

    $ git clone https://github.com/rlyon/midwife.git

## Usage

#### TODO: Write usage instructions here

## Contributing

### Grab the source and make a branch

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Seting up for the kickstart validation tests

To run the kickstart validation tests on your local system, you
will need an install of python.  I'm using 2.7, I don't know if
it makes a difference.  On Mac use homebrew or macports to avoid
using the system python which is bound to be really, really old.
On Linux you can use your favorite package manager.

    $ brew install python
    $ pip install virtualenv

Once python has been installed, run

    $ rake validator:setup

This will create the directories that you need, set up a virtual
environment and get everything ready for the integration tests.

### Run the tests to see if it breaks

    $ rake test
