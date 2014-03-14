#!/bin/sh

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

echo "Setup complete"