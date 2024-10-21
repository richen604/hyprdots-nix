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

echo "This script provides instructions for setting up NixOS as a host for running VMs."
echo "The required configuration includes enabling libvirtd, adding your user to the libvirt group, and installing virt-manager."
echo "These changes are necessary to create and manage virtual machines on your NixOS system."

echo "To set up NixOS as a host for running VMs, add the following to your configuration.nix:"
echo
echo "virtualisation.libvirtd.enable = true;"
echo "users.users.<your-username>.extraGroups = [ \"libvirtd\" ];"
echo "environment.systemPackages = with pkgs; [ virt-manager ];"
echo
echo "Then, run 'sudo nixos-rebuild switch' to apply the changes."
