#!/usr/bin/env bash
set -e

CONFIG=config.yaml

ISO_DIR="iso"
ISO=$(yq -r '.w19.windows.virtio_iso' $CONFIG)

URL="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"

mkdir -p $ISO_DIR

if [ -f "$ISO" ]; then
    echo "VirtIO ISO already exists"
    exit 0
fi

echo "Downloading VirtIO drivers..."

curl -L $URL -o $ISO