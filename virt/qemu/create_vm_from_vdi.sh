#!/bin/bash

if [ x$1 == "x--help" -o x$1 == "x-h" ]; then
	echo "Usage: $0 <vm_name> <\$vbox.vdi>"
	echo "Example: $0 astra /mnt/vms/VBox/astra/astra.vdi"
	echo "<\$vbox.vdi> is vdi image which will be converted to \$vm_name.qcow2"
	exit 0
fi

if [ $# -eq 0 ]; then
	echo "Usage: $0 <vm_name> <\$vbox.vdi to convert>"
	echo "Example: $0 astra /mnt/vms/VBox/astra/astra.vdi"
	exit 0
fi

if [ x$1 == x ]; then 
	echo No name passed. Exit.
	echo "Usage: $0 <vm_name> <\$vbox.vdi to convert>"
	echo "Example: $0 astra /mnt/vms/VBox/astra/astra.vdi"
	exit 1
fi

NAME=$1
VM_DIR=$(readlink -f $NAME)
SCRIPT_DIR=$(dirname $(readlink -f $0))

$SCRIPT_DIR/new_vm.sh $NAME

echo Create image...

IMG=$VM_DIR/$NAME
VBOX=$(readlink -f "$2")
IMG=$VM_DIR/$NAME.qcow2

echo "$VBOX ---> $IMG"

$SCRIPT_DIR/convert_vbox_to_qemu.sh "$VBOX" "$IMG
echo "$IMG is created"
