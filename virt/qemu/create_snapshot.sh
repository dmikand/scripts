#!/bin/bash

OUT=snapshot.qcow2

if [ x$1 == "x--help" ]; then
	echo "Usage: $0 <base disk> [<snapshot name>]"
	exit 1
fi

if [ x$1 == x ]; then
	echo No base disk specified.
	echo "Usage: $0 <base disk> [<snapshot name>]"
	exit 1
fi

if [ x$2 != x ]; then
	OUT=$2
fi

qemu-img create -f qcow2 -b "$1" $OUT
