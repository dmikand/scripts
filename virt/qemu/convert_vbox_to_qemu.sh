#!/bin/bash

INFILE=$1
OUTFILE=$(readlink -f "$2")

qemu-img convert -f vdi -O qcow2 "$INFILE" "$OUTFILE"

