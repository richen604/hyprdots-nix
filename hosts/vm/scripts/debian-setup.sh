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

echo "This script will install the necessary dependencies for running VMs on Debian."
echo "These dependencies include QEMU, libvirt, and virt-manager, which are required for creating and managing virtual machines."
echo "The script will also configure your system to run libvirtd service and add your user to the libvirt group."

read -p "Do you want to proceed with the installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Installation cancelled."
    exit 1
fi

# Update package lists
sudo apt update

# Install required packages
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

# Add user to libvirt group
sudo usermod -aG libvirt $USER

# Start and enable libvirtd service
sudo systemctl enable --now libvirtd

echo "Debian host dependencies installed successfully."
echo "Please log out and log back in for group changes to take effect."
