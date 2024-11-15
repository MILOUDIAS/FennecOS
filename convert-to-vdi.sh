!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 input_image.img"
	exit 1
fi

input_img=$1
output_vdi="${input_img%.*}.vdi"

qemu-img convert -O vdi "$input_img" "$output_vdi"
