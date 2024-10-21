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

echo "This script will set up Debian for Hydenix."
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

echo "Setting up Debian with the following configuration:"
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

# Update system
sudo apt update && sudo apt upgrade -y

# Install necessary packages
sudo apt install -y \
    zsh \
    policykit-1 \
    bluez \
    pipewire \
    pipewire-audio-client-libraries \
    wireplumber \
    dbus \
    udisks2 \
    openssh-server \
    sddm \
    network-manager \
    upower

# Enable and start services
sudo systemctl enable --now \
    bluetooth \
    pipewire \
    pipewire-pulse \
    ssh \
    NetworkManager \
    upower

# Set up firewall
sudo ufw allow 22/tcp
sudo ufw allow 4713/tcp
sudo ufw allow 4713/udp
sudo ufw allow 68/udp
sudo ufw allow 546/udp
sudo ufw enable

# Set timezone
sudo timedatectl set-timezone "$TIMEZONE"

# Set locale
sudo localectl set-locale LANG="$LOCALE"

# Create user
sudo useradd -m -G sudo,video -s /bin/zsh "$USERNAME"
echo "$USERNAME:$DEFAULT_PASSWORD" | sudo chpasswd

# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Source Nix
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "Debian setup complete. Please reboot the system."
