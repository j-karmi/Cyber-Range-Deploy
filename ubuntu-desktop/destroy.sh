#!/bin/bash

# Mini script pro vraceni systemu do puvodniho stavu

# Konfiguracni soubor
CONFIG=config.yaml
# Nazev slozky pro build

NAME=$(yq -r '.ubu.vm.name' $CONFIG)
BUILD=build-$NAME
DISK_NAME=disk

virsh destroy $NAME
virsh undefine --nvram $NAME
rm $BUILD/$DISK_NAME.qcow2