#!/usr/bin/env bash

set -e

echo "== Update =="
sudo dnf upgrade -y


echo "== Build tools =="
sudo dnf group install -y development-tools
sudo dnf group install -y c-development
sudo dnf group install -y rpm-development-tools


echo "== Compiler/autotools =="
sudo dnf install -y \
gcc \
gcc-c++ \
make \
cmake \
ninja-build \
autoconf \
automake \
libtool \
pkgconf \
pkgconf-pkg-config \
patch \
diffutils


echo "== Python =="
sudo dnf install -y \
python3-devel \
python3-pip \
python3-setuptools \
python3-wheel \
python3-pytest


echo "== RPM stack =="
sudo dnf install -y \
rpm-devel \
rpm-build \
rpmdevtools \
redhat-rpm-config \
rpmlint


echo "== Archive/compression =="
sudo dnf install -y \
libarchive-devel \
zlib-devel \
bzip2-devel \
xz-devel \
lz4-devel \
zstd-devel


echo "== GTK =="
sudo dnf install -y \
gtk3-devel \
gtk4-devel \
glib2-devel \
gobject-introspection-devel \
cairo-devel \
pango-devel


echo "== Storage =="
sudo dnf install -y \
parted-devel \
device-mapper-devel \
libblockdev-devel \
cryptsetup-devel \
e2fsprogs-devel \
xfsprogs-devel


echo "== System =="
sudo dnf install -y \
systemd-devel \
libffi-devel \
openssl-devel \
libselinux-devel \
libcap-devel


echo "== Networking =="
sudo dnf install -y \
libcurl-devel \
librepo-devel \
libdnf-devel \
libsolv-devel


echo "== Python packages =="
python3 -m pip install --upgrade pip

python3 -m pip install \
build \
meson \
ninja \
pytest


echo "Done!"
