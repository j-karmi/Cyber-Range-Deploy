#!/bin/bash

# Mini script pro usnadneni testovani

# Konfiguracni soubor
CONFIG=config.yaml
# Nazev slozky pro build
BUILD=build

NAME=$(yq -r '.w19.vm.name' $CONFIG)

DISK_NAME=disk

virsh destroy $NAME
virsh undefine --nvram $NAME
rm $BUILD/$DISK_NAME.qcow2