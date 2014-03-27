# Midwife
[![Build Status](https://travis-ci.org/rlyon/midwife.png?branch=master)](https://travis-ci.org/rlyon/midwife)
[![Coverage Status](https://coveralls.io/repos/rlyon/midwife/badge.png)](https://coveralls.io/r/rlyon/midwife)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'midwife'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install midwife

## Usage

TODO: Write usage instructions here

## Contributing

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

