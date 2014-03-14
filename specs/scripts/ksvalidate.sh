#!/bin/sh

TESTPATH=$1
KSPATH=$2
VER=$3
mkdir $TESTPATH
cd $TESTPATH

if [ -z $TRAVIS ] ; then
  mkdir -p ksvalidation
  pushd ksvalidation
  pip install pycurl
  pip install urlgrabber
  # Should prabably just package the source up
  git clone git://git.fedorahosted.org/git/pykickstart.git
  pushd pykickstart
  python setup.py install
  popd
else
  if ! [ -f "./ksvalidation/bin/activate" ] ; then
    echo "Please run 'rake ksvalidate:setup' to ensure that the virtual"
    echo "environment is set up before running the integration tests or set"
    echo "NOVALIDATE before you run"
    exit 1
  fi

  pushd ksvalidation
  source bin/activate
fi

ksvalidator -v $VER $KSPATH 2>error.log 1>output.log
