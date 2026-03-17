#!/usr/bin/env bash
set -e

ISO_DIR="iso"
ISO_NAME="windows_server_2019_eval.iso"
URL="https://go.microsoft.com/fwlink/p/?LinkID=2195167&clcid=0x409&culture=en-us&country=US"


mkdir -p $ISO_DIR

if [ -f "$ISO_DIR/$ISO_NAME" ]; then
    echo "Windows ISO already exists"
    exit 0
fi

echo "Stahuji Windows 10 ISO..."

curl -L $URL -o $ISO_DIR/$ISO_NAME
echo "ISO staženo do:"
echo "$ISO_DIR/$ISO_NAME"




