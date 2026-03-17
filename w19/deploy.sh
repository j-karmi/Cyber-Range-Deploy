#!/usr/bin/env bash
set -e

CONFIG=config.yaml

echo "=== Windows 2019 VM deployment ==="

./scripts/download_windows_2019.sh
./scripts/download_virtio.sh
./scripts/generate_autounattend.sh
./scripts/create_vm.sh

echo
echo "Deployment started successfully."