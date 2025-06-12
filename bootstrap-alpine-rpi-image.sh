#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root."
  exit 1
fi
# Parse named arguments
while getopts "i:r:" opt; do
  case "$opt" in
    i) image_file="$OPTARG" ;;
    r) raw_device="$OPTARG" ;;
    \?) echo "Usage: $0 -i <image_file> -r <raw_device>"
        exit 1
        ;;
  esac
done

# Check if required arguments are provided
if [ -z "$image_file" ] || [ -z "$raw_device" ]; then
  echo "Usage: $0 -i <image_file> -r <raw_device>"
  exit 1
fi

# Check if the image file exists
if [ ! -f "$image_file" ]; then
  echo "Error: Image file '$image_file' does not exist."
  exit 1
fi

# Check if the raw device exists
if [ ! -b "$raw_device" ]; then
  echo "Error: Raw device '$raw_device' does not exist."
  exit 1
fi

# Unmount any existing mounts on the target device to prevent 'device busy' errors
umount "${raw_device}"* 2>/dev/null || true
# Does not boot on Raspberry Pi 3 when using GPT
# Use msdos partition table instead for compatibility
parted "${raw_device}" mklabel msdos
parted "${raw_device}" mkpart primary fat32 1MiB 4096MiB
# Make partition bootable
parted "${raw_device}" set 1 boot on
mkfs.vfat -F 32 "${raw_device}"1
parted "${raw_device}" mkpart primary ext4 4096MiB 100%
mkfs.ext4 -F "${raw_device}"2

mount "${raw_device}"1 /mnt
tar -zxf "$image_file" -C /mnt
umount /mnt



