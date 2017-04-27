#!/usr/bin/env bash
echo "Creating virtual environment: ksvalidator"
virtualenv specs/ksvalidator
echo "Activating!!!"
. ./specs/ksvalidator/bin/activate

echo "Installing packages"
pip install -r ./specs/scripts/requirements.txt

cd ./specs/ksvalidator
git clone https://github.com/rhinstaller/pykickstart
cd pykickstart
python setup.py install

which ksvalidator
env
echo "Setup complete"
