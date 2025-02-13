#!/bin/bash

NAME=image
SIZE=10G

if [ x$1 == "x--help" ]; then
	echo "Usage: $0 <image name> [<size>]"
	echo "Example: $0 foo 30G"
	exit 1
fi

NAME=$1

if [ x$2 != x ]; then
	SIZE=$2
fi

qemu-img create -f qcow2 $NAME.qcow2 $SIZE
