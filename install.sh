#! /bin/bash

set -ouex pipefail

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo

mkdir -p /tmp/rpms

RELEASE="$(rpm -E %fedora)"

RPMFUSION_MIRROR_RPMS="https://mirrors.rpmfusion.org"

curl -Lso /tmp/rpms/rpmfusion-free-release-${RELEASE}.noarch.rpm ${RPMFUSION_MIRROR_RPMS}/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm > /dev/null
curl -Lso /tmp/rpms/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm ${RPMFUSION_MIRROR_RPMS}/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm > /dev/null

rpm-ostree install /tmp/rpms/*.rpm
sed -i '0,/enabled=0/{s/enabled=0/enabled=1\npriority=110/}' /etc/yum.repos.d/rpmfusion-*-updates-testing.repo

rpm-ostree install /tmp/kmod-rpms/*.rpm

# Install packages from packages.json

INCLUDED_PACKAGES=($(jq -r '.include | sort | unique[]' /tmp/packages.json))
EXCLUDED_PACKAGES=($(jq -r '.exclude | sort | unique[]' /tmp/packages.json))

# Only exclude packages present in image
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
  EXCLUDED_PACKAGES=($(rpm -qa --queryformat '%{NAME} ' ${EXCLUDED_PACKAGES[@]}))  
fi

if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
  rpm-ostree override remove ${EXCLUDED_PACKAGES[@]}
fi

if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 ]]; then
  rpm-ostree install ${INCLUDED_PACKAGES[@]}
fi