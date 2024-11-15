#!/bin/bash

# qemu-system-x86_64 -m 2G -drive file=fs.qcow2,format=qcow2 \
# -netdev bridge,id=net0,br=br0 -device virtio-net-pci,netdev=net0 -enable-kvm

# Check if the disk image argument is passed
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <path_to_disk_image>"
	exit 1
fi

DISK_IMAGE=$1
MEMORY="3G"

# Run QEMU with the provided disk image
echo "Starting QEMU with disk image: $DISK_IMAGE"
# qemu-system-x86_64 -m $MEMORY \
# 	-drive file="$DISK_IMAGE",format=qcow2 \
# 	-net nic -net user \
# 	-cpu host -enable-kvm
#
# qemu-system-x86_64 -drive file="$DISK_IMAGE",format=raw -m $MEMORY -serial mon:stdio
#
qemu-system-x86_64 -drive file="$DISK_IMAGE" \
	-net nic -net user,hostfwd=tcp::2222-:22 -m $MEMORY \
	-cpu host -enable-kvm \
	-serial mon:stdio

# qemu-system-x86_64 -m $MEMORY -drive file="$DISK_IMAGE",format=qcow2 \
# 	-netdev bridge,id=net0,br=br0 -device virtio-net-pci,netdev=net0 -enable-kvm
# End of script
