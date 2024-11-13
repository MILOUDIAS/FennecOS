qemu-system-x86_64 -drive format=raw,file=./fennecos-x86_64.img -net nic -net user -m 3G -cpu host -enable-kvm -smp 2
#
# qemu-system-x86_64 \
# 	-drive format=raw,file=./fennecos-x86_64.img \
# 	-vga virtio \
# 	-device virtio-vga \
# 	-m 3G \
# 	-net nic -net user \
# 	-cpu host -enable-kvm \
# 	-smp 2
# -display sdl

# qemu-system-x86_64 \
# 	-drive format=raw,file=./fennecos-x86_64.img \
# 	-device virtio-gpu-pci \
# 	-display gtk,gl=on \
# 	-vga none \
# 	-m 3G \
# 	-net nic -net user \
# 	-cpu host -enable-kvm \
# 	-smp 2
