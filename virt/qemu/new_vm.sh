#!/bin/bash

if [ x$1 == "x--help" -o x$1 == "x-h" ]; then
	echo "Usage: $0 <vm_name>"
	echo "Example: $0 astra"
	exit 0
fi

if [ $# -eq 0 ]; then
	echo "Usage: $0 <vm_name>"
	echo "Example: $0 astra"
	exit 0
fi


if [ x$1 == x ]; then 
	echo No name passed. Exit.
	echo "Usage: $0 <vm_name>"
	echo "Example: $0 astra"
	exit 1
fi

NAME=$1
VM_SCRIPTS_PATH=/mnt/vms/qemu/scripts
VM_MAC_ADDR_FORMAT_STRING='DE:AD:BE:EF:%02X:%02X\n'

if [ -e $NAME ]; then
	echo $NAME is exist. Exit.
	exit 1
fi

mkdir $NAME
VM_DIR=$(readlink -f $NAME)

echo VM creation: $VM_DIR

echo run.sh generation

cat > $VM_DIR/run.sh  <<EOF
#!/bin/bash

FWD_STATE=\$(cat /proc/sys/net/ipv4/ip_forward)

BASE_DIR=\$(dirname \$(readlink -f \$0))

SCRIPTS_PATH=\${VM_SCRIPTS_PATH}
IFUP=\$SCRIPTS_PATH/if-up.sh
IFDOWN=\$SCRIPTS_PATH/if-down.sh
VM_PATH=\$(readlink -f \$(dirname \$0))
COM_PORTS=\$VM_PATH/ports
COM1=\$COM_PORTS/com1

MAC=\$(printf '\${VM_MAC_ADDR_FORMAT_STRING}' \$((RANDOM%256)) \$((RANDOM%256)))
qemu-system-x86_64 $VM_DIR/snapshot.qcow2 -snapshot -m 1024 \\
	-name $NAME -daemonize -serial file:\$COM1 \\
	-device pcnet,netdev=qemu_net,mac=\$MAC \\
	-netdev tap,id=qemu_net,script=\$IFUP,downscript=\$IFDOWN \\
	\$@
EOF

chmod +x $VM_DIR/run.sh

echo run_$NAME.sh generation

cat > $VM_DIR/run_$NAME.sh  <<EOF
#!/bin/bash

FWD_STATE=\$(cat /proc/sys/net/ipv4/ip_forward)

BASE_DIR=\$(dirname \$(readlink -f \$0))

SCRIPTS_PATH=\${VM_SCRIPTS_PATH}
IFUP=\$SCRIPTS_PATH/if-up.sh
IFDOWN=\$SCRIPTS_PATH/if-down.sh
VM_PATH=\$(readlink -f \$(dirname \$0))
COM_PORTS=\$VM_PATH/ports
COM1=\$COM_PORTS/com1

MAC=\$(printf '\${VM_MAC_ADDR_FORMAT_STRING}' \$((RANDOM%256)) \$((RANDOM%256)))
qemu-system-x86_64 $VM_DIR/$NAME.qcow2 -m 2048 \\
	-name $NAME -daemonize -serial file:\$COM1 \\
	-device pcnet,netdev=qemu_net,mac=\$MAC \\
	-netdev tap,id=qemu_net,script=\$IFUP,downscript=\$IFDOWN \\
	-enable-kvm \\
	\$@
EOF

chmod +x $VM_DIR/run_$NAME.sh

mkdir -p $VM_DIR/ports



