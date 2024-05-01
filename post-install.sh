#! /bin/bash

set -ouex pipefail

# Set os-release and color

sed -i 's/Fedora Linux/RaduLinux/g' /etc/os-release
sed -i 's/ANSI_COLOR="[^"]*"/ANSI_COLOR="0;38;2;205;0;0"/' /etc/os-release # RGB 205 0 0
sed -i 's/ID=fedora/ID=radulinux/g' /etc/os-release
sed -i 's/CPE_NAME="[^"]*"//' /etc/os-release
sed -i 's/DEFAULT_HOSTNAME="[^"]*"/DEFAULT_HOSTNAME="radulinux"/' /etc/os-release
sed -i 's/HOME_URL="[^"]*"/HOME_URL="https:\/\/github.com\/RaduLinux\/RaduLinux"/' /etc/os-release
sed -i 's/DOCUMENTATION_URL="[^"]*"//' /etc/os-release
sed -i 's/SUPPORT_URL="[^"]*"//' /etc/os-release
sed -i 's/BUG_REPORT_URL="[^"]*"/BUG_REPORT_URL="https:\/\/github.com\/RaduLinux\/RaduLinux\/issues"/' /etc/os-release
sed -i 's/REDHAT_.*//g' /etc/os-release

sed -i '/^$/d' /etc/os-release

# Set system-release

sed -i 's/Fedora/RaduLinux/g' /etc/system-release

# Generate initramfs

KERNEL_VERSION=$(rpm -q kernel --qf "%{VERSION}-%{RELEASE}.%{ARCH}")
dracut --no-hostonly --kver $KERNEL_VERSION --reproducible -v --add ostree -f /lib/modules/$KERNEL_VERSION/initramfs.img

chmod 600 /lib/modules/$KERNEL_VERSION/initramfs.img