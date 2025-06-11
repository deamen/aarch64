# bootstrap-alpine-rpi-image.sh

This script automates the process of bootstrapping an Alpine Linux image for Raspberry Pi devices. 

## Features
- Prepares and partitions an SD card
- Installs the Alpine system for Raspberry Pi

## Usage

```sh
bash bootstrap-alpine-rpi-image.sh [options]
```

### Options
- `-i <image_file>`: The image file to use (e.g., alpine-rpi-3.22.0-aarch64.tar.gz)
- `-r <raw_device>`: Raw device to use (e.g., /dev/sdX)

**Example:**


```sh
sudo bash bootstrap-alpine-rpi-image.sh -i alpine-rpi-3.22.0-aarch64.tar.gz -r /dev/sdX
```

## Prerequisites
- Linux host system
- `mkfs.vfat`, `mkfs.ext4`, `parted`, and other standard utilities

## Notes
- All data on the target device will be erased.
- Script should be run with sudo privileges.
- Review the script before running to ensure it matches your requirements.
- Ensure the tarball image(.tar.gz) is used instead of the raw image(.img.gz).

## References
- [Alpine Linux for Raspberry Pi](https://wiki.alpinelinux.org/wiki/Raspberry_Pi)
- [Alpine aarch64 Downloads](https://alpinelinux.org/downloads/)

