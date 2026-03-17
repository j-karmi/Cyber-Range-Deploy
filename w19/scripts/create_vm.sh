#!/bin/bash

# Konfiguracni soubor
CONFIG=config.yaml
# Nazev slozky pro build
BUILD=build

NAME=$(yq -r '.w19.vm.name' $CONFIG)
RAM=$(yq -r '.w19.vm.ram' $CONFIG)
VCPUS=$(yq -r '.w19.vm.vcpus' $CONFIG)
DISK=$(yq -r '.w19.vm.disk_size' $CONFIG)
ISO=$(yq -r '.w19.windows.iso' $CONFIG)
VIRTIO_ISO=$(yq -r '.w19.windows.virtio_iso' $CONFIG)
VARIANT=$(yq -r '.w19.windows.edition' $CONFIG)

DISK_NAME=disk

#=====================================
# Rezervuji misto na virtualni hdd na disku
echo "Creating disk..."
qemu-img create -f qcow2 $BUILD/$DISK_NAME.qcow2 $DISK

#=====================================
# Zacinam s instalaci 
echo "Starting VM install..."

virt-install \
 --name $NAME \
 --ram $RAM \
 --vcpus $VCPUS \
 --disk size=20,bus=virtio \
 --disk path=$BUILD/$DISK_NAME.qcow2,format=qcow2,bus=virtio \
 --cdrom $ISO \
 --disk path=$BUILD/autounattend.iso,device=cdrom \
 --disk path=$VIRTIO_ISO,device=cdrom \
 --os-variant $VARIANT \
 --boot uefi \
 --graphics spice
