#!/bin/bash

# For Allwinner
#./prep-fedora-image.sh -i ./Fedora-Server-39_Beta-1.1.aarch64.raw -o ./Fedora-Server-39_Beta-1.1.aarch64-opizw3.raw -u  u-boot-builder/out/u-boot-orangepi-zero3-with-spl.bin -s 8
## For rockchip
#./prep-fedora-image.sh -i ./Fedora-Server-39_Beta-1.1.aarch64.raw -o ./Fedora-Server-39_Beta-1.1.aarch64-opizw3.raw -u  u-boot-builder/out/u-boot-orangepi-zero3-with-spl.bin -s 32

# Initialize variables with default values
input_file=""
output_file=""
uboot_file=""
dtb_file=""

# Parse named arguments
while getopts "i:o:u:d:s:f:" opt; do
  case "$opt" in
    i) input_file="$OPTARG" ;;
    o) output_file="$OPTARG" ;;
    u) uboot_file="$OPTARG" ;;
    d) dtb_file="$OPTARG" ;;
    s) seek="$OPTARG" ;;
    f) folder="$OPTARG" ;;
    \?) echo "Usage: $0 -i <input_image_file> -o <output_image_file> -u <uboot_file> -s <seek> [-d <dtb_file>] [-f <folder>]"
        exit 1
        ;;
  esac
done

# Check if required arguments are provided
if [ -z "$input_file" ] || [ -z "$output_file" ] || [ -z "$uboot_file"  ] || [ -z "$seek"  ]; then
  echo "Usage: $0 -i <input_image_file> -o <output_image_file> -u <uboot_file> -s <seek> [-d <dtb_file>] [-f <folder>]"
  exit 1
fi

# Copy the original image
cp "$input_file" "$output_file"

# Append 1GiB of zeroes to the end of the image
dd if=/dev/zero bs=1M count=1024 >> "$output_file"

# Move the partitions within the image to create space at the front
#for i in 3 2 1; do
#  echo "+16MiB" | sfdisk --move-data "$output_file" -N $i
#done

# Move the rootfs partition to the end of the image
echo "+1024MiB" | sfdisk --move-data "$output_file" -N 3

# Move the /boot partition so there is 512MiB freespace after it
echo "+512MiB" | sfdisk --move-data "$output_file" -N 2

# Extend the /boot partition
echo ", +" | sfdisk -N 2 "$output_file"

# Move the /boot/efi partition so it starts from 16MiB
echo "+16MiB" | sfdisk --move-data "$output_file" -N 1
# Extend the /boot/efi partition
echo ", +" | sfdisk -N 1 "$output_file"

# Set up a loop device for the image file
loop_device=$(sudo losetup --find --show -Pf "$output_file")

# Write the u-boot bootloader to the image file
sudo dd if="$uboot_file" of="$loop_device" bs=1K seek=$seek

# If a dtb_file is provided, copy it to the first partition of the image
if [ -n "$dtb_file" ]; then
  sudo mount "${loop_device}p1" /mnt
  sudo mkdir -p /mnt/${folder}
  sudo cp "$dtb_file" /mnt/${folder}/
  sudo umount /mnt
fi

# Clean up by removing the loop device
sudo losetup -d "$loop_device"

