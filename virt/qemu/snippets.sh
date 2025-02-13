.sh
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

SCRIPTS_PATH=\$(readlink -f \$BASE_DIR/../scripts)
IFUP=\$SCRIPTS_PATH/if-up.sh
IFDOWN=\$SCRIPTS_PATH/if-down.sh
VM_PATH=\$(readlink -f \$(dirname \$0))
COM_PORTS=\$VM_PATH/ports
COM1=\$COM_PORTS/com1

MAC=\$(printf 'DE:AD:BE:EF:%02X:%02X\n' \$((RANDOM%256)) \$((RANDOM%256)))
qemu-system-x86_64 \$BASE_DIR/snapshot.qcow2 -snapshot -m 1024 \\
	-name $NAME -daemonize -s -serial file:\$COM1 \\
	-device pcnet,netdev=qemu_net,mac=\$MAC \\
	-netdev tap,id=qemu_net,script=\$IFUP,downscript=\$IFDOWN \\
	\$@
EOF

chmod +x $VM_DIR/run.sh

echo run-$NAME.sh generation

cat > $VM_DIR/run-$NAME.sh  <<EOF
#!/bin/bash

FWD_STATE=\$(cat /proc/sys/net/ipv4/ip_forward)

BASE_DIR=\$(dirname \$(readlink -f \$0))

SCRIPTS_PATH=\$(readlink -f \$BASE_DIR/../scripts)
IFUP=\$SCRIPTS_PATH/if-up.sh
IFDOWN=\$SCRIPTS_PATH/if-down.sh
VM_PATH=\$(readlink -f \$(dirname \$0))
COM_PORTS=\$VM_PATH/ports
COM1=\$COM_PORTS/com1

MAC=\$(printf 'DE:AD:BE:EF:%02X:%02X\n' \$((RANDOM%256)) \$((RANDOM%256)))
qemu-system-x86_64 \$BASE_DIR/$NAME.qcow2 -m 2048 \\
	-name $NAME -daemonize -s -serial file:\$COM1 \\
	-chardev pty,id=${NAME}_com2 -serial chardev:${NAME}_com2      \\
	-device pcnet,netdev=qemu_net,mac=\$MAC \\
	-netdev tap,id=qemu_net,script=\$IFUP,downscript=\$IFDOWN \\
	-enable-kvm \\
	\$@
EOF

chmod +x $VM_DIR/run-$NAME.sh

mkdir -p $VM_DIR/ports

if [ "$2" == "" ]; then exit 0; fi

echo Converting images...

SCRIPT_DIR=$(dirname $(readlink -f $0))
VBOX=$(readlink -f "$2")
IMG=$VM_DIR/$NAME.qcow2

echo "$VBOX ---> $IMG"

$SCRIPT_DIR/convert_vbox_to_qemu.sh "$VBOX" "$IMG"