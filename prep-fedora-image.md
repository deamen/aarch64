# prep-fedora-image.sh
## Available options
* -i <input file> - input image file
* -o <output file> - output image file
* -u <u-boot file> - u-boot file
* -d <dtb file> - dtb file
* -s <sector offset> - sector offset
* -f <flash type> - flash type (allwinner, amlogic, rockchip)

## How to customize official Fedora image for Orange Pi Zero3
```bash
wget -c https://github.com/deamen/u-boot-builder/releases/download/orangepi_zero3.v2023.11.7/u-boot_orangepi_zero3.bin
wget -c https://github.com/deamen/dtb-builder/releases/download/orangepi_zero3.v2023.11.7.2/dtb_orangepi_zero3.dtb -O sun50i-h616-orangepi-zero3.dtb
wget -c https://d2lzkl7pfhq30w.cloudfront.net/pub/fedora/linux/releases/39/Server/aarch64/images/Fedora-Server-39-1.5.aarch64.raw.xz
xz -d Fedora-Server-39-1.5.aarch64.raw.xz
./prep-fedora-image.sh -i ./Fedora-Server-39-1.5.aarch64.raw -o ./Fedora-Server-39-1.5.aarch64-opizw3.raw -u  u-boot_orangepi_zero3.bin -s 8 -d sun50i-h616-orangepi-zero3.dtb -f allwinner
```

## How to customize official Fedora image for NanoPi R4S
```bash
wget -c https://github.com/deamen/u-boot-builder/releases/download/nanopi-r4s.v2023.11.7/u-boot_nanopi-r4s.bin
wget -c https://github.com/deamen/dtb-builder/releases/download/nanopi-r4s.v2023.11.7/dtb_nanopi-r4s.dtb -O rk3399-nanopi-r4s.dtb
wget -c https://d2lzkl7pfhq30w.cloudfront.net/pub/fedora/linux/releases/39/Server/aarch64/images/Fedora-Server-39-1.5.aarch64.raw.xz
xz -d Fedora-Server-39-1.5.aarch64.raw.xz
./prep-fedora-image.sh -i ./Fedora-Server-39-1.5.aarch64.raw -o ./Fedora-Server-39-1.5.aarch64-nanopi-r4s.raw -u  u-boot_nanopi-r4s.bin -s 32 -d rk3399-nanopi-r4s.dtb -f rockchip
```