#!/bin/bash

/sbin/iptables -t nat -A POSTROUTING -o wlp3s0 -j MASQUERADE
/sbin/iptables -A FORWARD -i wlp3s0 -o qemu_br0 -m state --state RELATED,ESTABLISHED -j ACCEPT
 
/sbin/iptables -A FORWARD -i qemu_br0 -o wlp3s0 -j ACCEPT


