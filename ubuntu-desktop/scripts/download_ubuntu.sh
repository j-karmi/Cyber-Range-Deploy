#!/bin/bash

set -e

CONFIG=config.yaml

ISO_DIR="iso"
ISO_SERVER=$(yq -r '.ubu.os.iso_path' $CONFIG)
ISO_NAME=$(yq -r '.ubu.os.iso' $CONFIG)
ISO_PATH="$ISO_DIR/$ISO_NAME"

ISO_URL="$ISO_SERVER/$ISO_NAME"
SHA_URL="$ISO_SERVER/SHA256SUMS"

mkdir -p "$ISO_DIR"
echo $ISO_PATH
if [ -f "$ISO_PATH" ]; then
    echo "ISO už existuje: $ISO_PATH"
    echo "Přeskakuji stahování."
else
    echo "Stahuji ISO..."
    wget -O "$ISO_PATH" "$ISO_URL"
fi

#echo "Stahuji SHA256SUMS..."
#wget -q -O "$ISO_DIR/SHA256SUMS" "$SHA_URL"

#echo "Ověřuji checksum..."

#cd "$ISO_DIR"

#grep "$ISO_NAME" SHA256SUMS | sha256sum -c -

#echo "ISO je validní."