# qemu-system-x86_64 -drive format=raw,file=./fennecos.img
qemu-system-x86_64 -drive format=raw,file=./fennecos.img -net nic -net user -m 2048 -cpu host -enable-kvm -serial stdio
