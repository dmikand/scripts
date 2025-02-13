#!/bin/bash

if [ x$1 == x ]; then 
	echo "Usage: $0 <external_ip> <external_port> <internal_ip> <internal_port>"
	exit 0
fi

#iptables -t nat -I PREROUTING --dst 192.168.8.25 -p tcp -m tcp --dport 222 -j DNAT --to-destination 192.168.57.2:22
#iptables -t nat -A POSTROUTING -o qemu_br0 -j SNAT --to-source 192.168.8.25
EXT_IP=$1
EXT_PORT=$2
INT_IP=$3
INT_PORT=$4

iptables -t nat -A PREROUTING --dst $EXT_IP -p tcp --dport $EXT_PORT -j DNAT --to-destination $INT_IP:$INT_PORT
iptables -t nat -A POSTROUTING --dst $INT_IP -p tcp --dport $INT_PORT -j SNAT --to-source $INT_IP
