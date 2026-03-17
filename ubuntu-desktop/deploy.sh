#!/usr/bin/env bash
set -e

CONFIG=config.yaml

echo "=== Ubuntu Desktop VM deployment ==="
./scripts/download_ubuntu.sh
./scripts/generate_metadata.sh
./scripts/create_vm.sh

echo
echo "Deployment started successfully."