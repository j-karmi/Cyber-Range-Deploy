#!/bin/bash

# Mini script pro vraceni systemu do puvodniho stavu

# Konfiguracni soubor
CONFIG=config.yaml
# Nazev slozky pro build
BUILD=build

NAME=$(yq -r '.ubu.vm.name' $CONFIG)

DISK_NAME=disk

virsh destroy $NAME
virsh undefine --nvram $NAME
rm $BUILD/$DISK_NAME.qcow2