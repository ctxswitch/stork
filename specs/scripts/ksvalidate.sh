#!/bin/sh

TESTPATH=$1
KSPATH=$2
VER=$3
mkdir -p $TESTPATH
cd $TESTPATH

if ! [ "x${TRAVIS}" == "x" ] ; then
  mkdir -p ksvalidator
  pushd ksvalidator
  pip install pycurl
  pip install urlgrabber
  # Should prabably just package the source up
  git clone git://git.fedorahosted.org/git/pykickstart.git
  pushd pykickstart
  python setup.py install
  popd

else
  if ! [ -f "./ksvalidator/bin/activate" ] ; then
    echo "Please run 'rake ksvalidator:setup' to ensure that the virtual"
    echo "environment is set up before running the integration tests or set"
    echo "NOVALIDATE before you run"
    exit 1
  fi

  pushd ksvalidator
  source bin/activate
fi

ksvalidator -e -v $VER $KSPATH
exit $?
