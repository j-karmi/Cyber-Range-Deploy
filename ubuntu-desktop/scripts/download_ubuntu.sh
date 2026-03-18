#!/bin/bash

set -e

CONFIG=config.yaml

ISO_DIR="iso"
ISO_NAME=$(yq -r '.ubu.os.iso' $CONFIG)
ISO_PATH="$ISO_DIR/$ISO_NAME"

BASE_URL="https://releases.ubuntu.com/24.04"
ISO_URL="$BASE_URL/$ISO_NAME"
SHA_URL="$BASE_URL/SHA256SUMS"

mkdir -p "$ISO_DIR"

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