#!/bin/sh

echo "Starting setup"
if [ "${TRAVIS}" == "true" ] ; then
  sudo ip install pycurl
  sudo pip install urlgrabber
  git clone git://git.fedorahosted.org/git/pykickstart.git
  cd pykickstart
  sudo python setup.py install
else
  pip install virtualenv
  echo "Creating virtual environment: ksvalidator"
  virtualenv ksvalidator
  cd ksvalidator
  echo "Activating!!!"
  source bin/activate
  echo "Installing packages"
  pip install pycurl
  pip install urlgrabber
  git clone git://git.fedorahosted.org/git/pykickstart.git
  cd pykickstart
  python setup.py install
fi
echo "Setup complete"
