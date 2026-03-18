#!/usr/bin/env bash

echo "=== AUTOMATICKE NASAZENI VM WINDOWS A LINUX POMOCI QEMU/KVM ==="
echo "[1] Instalace Windows Server 2019"
echo "[2] Instalace Ubuntu Desktop"
echo "[3] Instalace obou Vms"
echo "[4] Konec"

read -p "Zadej volbu: " choice

case "$choice" in
    1)
        echo "Spoustim instalaci Windows Server 2019..."
        cd win19 || { echo "Slozka win19 nebyla nalezena"; exit 1; }
        ./deploy.sh
        ;;

    2)
        echo "Spoustim instalaci Ubuntu Desktop..."
        cd ubuntu-desktop || { echo "Slozka ubuntu-desktop nebyla nalezena"; exit 1; }
        ./deploy.sh
        ;;

    3)
        echo "Spoustim instalaci obou VM..."

        echo "Instalace Windows Server 2019..."
        (cd win19 && ./deploy.sh)

        echo "Instalace Ubuntu Desktop..."
        (cd ubuntu && ./deploy.sh)
        ;;

    4)
        echo "Ukoncuji skript."
        exit 0
        ;;

    *)
        echo "Neplatna volba."
        ;;
esac