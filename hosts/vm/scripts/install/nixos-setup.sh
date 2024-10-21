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

echo "This script will set up NixOS for Hydenix."
read -p "Do you want to proceed? (y/n) " REPLY
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Setup cancelled."
    exit 0
fi

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/hydenix/config.nix"

if [ -f "$CONFIG_FILE" ]; then
    echo "A config.nix file already exists at $CONFIG_FILE"
    read -p "Do you want to use the existing config? (y/n) " USE_EXISTING
    if [[ ! $USE_EXISTING =~ ^[Yy]$ ]]; then
        echo "Please run gen-config to create a new config file."
        exit 1
    fi
else
    echo "No config file found. Please run gen-config first."
    exit 1
fi

# Function to read values from config.nix
read_config() {
    nix eval --impure --expr "let config = import $CONFIG_FILE; in config.$1" 2>/dev/null | tr -d '"'
}

# Read configuration values
USERNAME=$(read_config "username")
TIMEZONE=$(read_config "timezone")
LOCALE=$(read_config "locale")
DEFAULT_PASSWORD=$(read_config "defaultPassword")

echo "Setting up NixOS with the following configuration:"
echo "Username: $USERNAME"
echo "Timezone: $TIMEZONE"
echo "Locale: $LOCALE"
echo

read -p "Is this correct? (y/n) " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]
then
    echo "Please update your config.nix file and run this script again."
    exit 1
fi

# Create a basic configuration.nix
sudo tee /etc/nixos/configuration.nix << EOF
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-hydenix";
  networking.networkmanager.enable = true;

  time.timeZone = "$TIMEZONE";

  i18n.defaultLocale = "$LOCALE";

  users.users.$USERNAME = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.zsh;
    initialPassword = "$DEFAULT_PASSWORD";
  };

  environment.systemPackages = with pkgs; [
    zsh
    git
    vim
  ];

  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
    };
  };

  hardware.bluetooth.enable = true;

  system.stateVersion = "23.11";
}
EOF

# Rebuild the system
sudo nixos-rebuild switch

echo "NixOS setup complete. Please reboot the system."
