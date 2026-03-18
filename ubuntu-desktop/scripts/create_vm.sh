#!/bin/bash

set -e

CONFIG=config.yaml

# Test dependenci ===================
require() {
command -v "$1" >/dev/null 2>&1 || { echo "$1 not installed"; exit 1; }
}

require virt-install
require qemu-img
require cloud-localds
require yq
require curl
require virsh
#====================================
#Parsovani config.yaml
NAME=$(yq -r '.ubu.vm.name' $CONFIG)
RAM=$(yq -r '.ubu.vm.ram' $CONFIG)
VCPUS=$(yq -r '.ubu.vm.vcpus' $CONFIG)
DISK=$(yq -r '.ubu.vm.disk_gb' $CONFIG)
ISO=$(yq -r '.ubu.os.iso' $CONFIG)
VARIANT=$(yq -r '.ubu.os.variant' $CONFIG)
HOSTNAME=$(yq -r '.ubu.system.hostname' $CONFIG)
TIMEZONE=$(yq -r '.ubu.system.timezone' $CONFIG)
LOCALE=$(yq -r '.ubu.system.locale' $CONFIG)
KEYBOARD=$(yq -r '.ubu.system.keyboard' $CONFIG)
NETWORK=$(yq -r '.ubu.network.libvirt_network' $CONFIG)
INDEX=$(yq -r '.ubu.web.index_file' $CONFIG)

WORKDIR="./build-$NAME"

#=====================================
# Rezervuji misto na virtualni hdd na disku
echo "Creating disk..."
qemu-img create -f qcow2 -F qcow2 \
-b $ISO $WORKDIR/disk.qcow2 20G

#=====================================
# Zacinam s instalaci 
echo "Starting VM install..."

virt-install \
 --name $NAME \
 --ram $RAM \
 --vcpus $VCPUS \
 --import \
 --disk path=$WORKDIR/disk.qcow2,format=qcow2,bus=virtio \
 --disk path=$WORKDIR/seed.iso,device=cdrom \
 --location iso/$ISO,kernel=casper/vmlinuz,initrd=casper/initrd \
 --os-variant $VARIANT \
 --graphics spice 
 #--extra-args "autoinstall ds=nocloud console=ttyS0"

