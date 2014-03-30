#!/bin/sh

echo "Installing packages"
if ! [ "$TRAVIS" == "true" ] ; then
  sudo pip install virtualenv
else
  pip install virtualenv
fi

echo "Creating virtual environment: ksvalidator"
virtualenv ksvalidator
cd ksvalidator
echo "Activating!!!"
source bin/activate

if ! [ "$TRAVIS" == "true" ] ; then
  sudo pip install pycurl
  sudo pip install urlgrabber
else
  pip install pycurl
  pip install urlgrabber
fi

git clone git://git.fedorahosted.org/git/pykickstart.git
cd pykickstart
python setup.py install

echo "Setup complete"
