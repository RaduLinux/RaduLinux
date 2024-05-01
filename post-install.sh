#! /bin/bash

set -ouex pipefail

# Set os name and color

sed -i 's/Fedora Linux/RaduLinux/g' /etc/os-release
sed -i 's/ANSI_COLOR="[^"]*"/ANSI_COLOR="0;38;2;205;0;0"/' /etc/os-release # RGB 205 0 0

# Generate initramfs

KERNEL_VERSION=$(rpm -q kernel --qf "%{VERSION}-%{RELEASE}.%{ARCH}")
dracut --no-hostonly --kver $KERNEL_VERSION --reproducible -v --add ostree -f /lib/modules/$KERNEL_VERSION/initramfs.img

chmod 600 /lib/modules/$KERNEL_VERSION/initramfs.img