#!/bin/bash

if [ x$1 == "x--help" ]; then
	echo No serial console specified
	echo "Usage: $0 <path_to_host_channel> [ path_to_PTY_link ]"
	exit 1
fi

if [ ! "$1" ]; then
	echo No serial console specified
	echo "Usage: $0 <path_to_host_channel> [ path_to_PTY_link ]"
	exit 1
fi

if [ "$2" ];then
	PTY=$2
else
	PTY=$1_pty
fi

nohup socat -d "$(readlink -f $1)" PTY,link=$PTY &


