#!/bin/bash


CONFIG=config.yaml
BUILD=build

mkdir -p $BUILD

ADMIN_NAME=$(yq -r '.w19.admin.username' $CONFIG)
ADMIN_PASS=$(yq -r '.w19.admin.password' $CONFIG)
USER_NAME=$(yq -r '.w19.user.username' $CONFIG)
USER_PASS=$(yq -r '.w19.user.password' $CONFIG)
USER_GROUPS=$(yq -r '.w19.user.groups' $CONFIG)

SYSTEM_NAME=$(yq -r '.w19.vm.name' $CONFIG)

# TO DO: dynamicky generovat blok pro vice uzivatelu. Ted to vezme pouze administrator + 1 user ucet
sed \
 -e "s|__ADMIN_PASS__|$ADMIN_PASS|g" \
 -e "s|__ADMIN_NAME__|$ADMIN_PASS|g" \
 -e "s|__USER_NAME__|$USER_NAME|g" \
 -e "s|__USER_PASS__|$USER_PASS|g" \
 -e "s|__USER_GROUPS__|$USER_GROUPS|g" \
 -e "s|__SYSTEM_NAME__|$SYSTEM_NAME|g" \
 templates/Autounattend.xml.template \
 > $BUILD/Autounattend.xml

genisoimage \
 -output $BUILD/autounattend.iso \
 -volid cidata \
 -joliet \
 -rock \
 $BUILD/Autounattend.xml templates/index.html scripts/setup_iis.ps1 