#!/usr/bin/env bash
echo "Starting setup"
if [ "$TRAVIS" = "true" ] ; then
  pip install pycurl
  pip install urlgrabber
  pip install requests
  pip install ordered_set
  git clone https://github.com/rhinstaller/pykickstart
  cd pykickstart
  python setup.py install
else
  # pip install virtualenv
  echo "Creating virtual environment: ksvalidator"
  virtualenv ksvalidator
  cd ksvalidator
  echo "Activating!!!"
  . ./bin/activate
  echo "Installing packages"
  pip install pycurl
  pip install urlgrabber
  pip install requests
  pip install ordered_set
  git clone https://github.com/rhinstaller/pykickstart
  cd pykickstart
  python setup.py install
fi

which ksvalidator
env
echo "Setup complete"
