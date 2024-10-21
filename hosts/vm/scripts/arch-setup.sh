#!/usr/bin/env bash

set -e

cat << "EOF"
  _    _           _            _
 | |  | |         | |          (_)
 | |__| |_   _  __| | ___ _ __  ___  __
 |  __  | | | |/ _` |/ _ \ '_ \| \ \/ /
 | |  | | |_| | (_| |  __/ | | | |>  <
 |_|  |_|\__, |\__,_|\___|_| |_|_/_/\_\
          __/ |
         |___/       ❄️ Powered by Nix ❄️
EOF

echo "This script will install the necessary dependencies for running VMs on Arch Linux."
echo "These dependencies include QEMU, libvirt, and virt-manager, which are required for creating and managing virtual machines."
echo "The script will also configure your system to run libvirtd service and add your user to the libvirt group."

read -p "Do you want to proceed with the installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Installation cancelled."
    exit 1
fi

# Install required packages
sudo pacman -S --noconfirm qemu libvirt virt-manager ebtables dnsmasq

# Start and enable libvirtd service
sudo systemctl enable --now libvirtd.service

# Add user to libvirt group
sudo usermod -aG libvirt $USER

echo "Arch Linux host dependencies installed successfully."
echo "Please log out and log back in for group changes to take effect."
