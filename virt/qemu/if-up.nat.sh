#!/bin/bash

sudo /sbin/brctl addif qemu_br1 $1
sudo /bin/ifconfig $1 0.0.0.0 promisc up

