#!/bin/bash

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

echo "This script will install the necessary dependencies for running VMs on macOS (Darwin)."
echo "These dependencies include QEMU and libvirt, which are required for creating and managing virtual machines."
echo "Note that GUI applications like virt-manager are not available on macOS, so you may need to use command-line tools or consider alternatives like UTM."

read -p "Do you want to proceed with the installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Installation cancelled."
    exit 1
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please install it first: https://brew.sh/"
    exit 1
fi

# Install required packages
brew install qemu libvirt

# Start libvirt service
brew services start libvirt

echo "macOS (Darwin) host dependencies installed successfully."
echo "Note: GUI applications like virt-manager are not available on macOS."
echo "You may need to use command-line tools or consider alternatives like UTM."
