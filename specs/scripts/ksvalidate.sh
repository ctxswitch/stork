#!/usr/bin/env bash

KSPATH=$1
VER=$2

if ! [ -f "./specs/ksvalidator/bin/activate" ] ; then
	echo "Please run 'rake ksvalidator:setup' to ensure that the virtual"
	echo "environment is set up before running the integration tests or set"
	echo "NOVALIDATE before you run"
	exit 1
fi

source ./specs/ksvalidator/bin/activate

ksvalidator -e -v $VER $KSPATH
exit $?
