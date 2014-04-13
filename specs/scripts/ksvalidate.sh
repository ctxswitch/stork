#!/usr/bin/env bash

TESTPATH=$1
KSPATH=$2
VER=$3
mkdir -p $TESTPATH
cd $TESTPATH

if [ "$TRAVIS" != "true" ] ; then
  if ! [ -f "./ksvalidator/bin/activate" ] ; then
    echo "Please run 'rake ksvalidator:setup' to ensure that the virtual"
    echo "environment is set up before running the integration tests or set"
    echo "NOVALIDATE before you run"
    exit 1
  fi
  cd ksvalidator
  source bin/activate
fi

ksvalidator -e -v $VER $KSPATH
exit $?
