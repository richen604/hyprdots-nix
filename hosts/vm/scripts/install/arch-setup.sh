#!/bin/bash
set -e

cat <<"EOF"
  _    _           _            _
 | |  | |         | |          (_)
 | |__| |_   _  __| | ___ _ __  ___  __
 |  __  | | | |/ _` |/ _ \ '_ \| \ \/ /
 | |  | | |_| | (_| |  __/ | | | |>  <
 |_|  |_|\__, |\__,_|\___|_| |_|_/_/\_\
          __/ |
         |___/       ❄️ Powered by Nix ❄️
EOF

echo "This script will set up Arch Linux for Hydenix."
# read -p "Do you want to proceed? (y/n) " REPLY
# echo
# if [[ ! $REPLY =~ ^[Yy]$ ]]; then
#     echo "Setup cancelled."
#     exit 0
# fi

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/hydenix/config.nix"

if [ -f "$CONFIG_FILE" ]; then
    echo "Config file found. Contents:"
    cat "$CONFIG_FILE"
else
    echo "Config file not found at $CONFIG_FILE"
    exit 1
fi

echo "Using config file: $CONFIG_FILE"

# Function to read values from config.nix
read_config() {
    local result
    result=$(grep "^[[:space:]]*$1[[:space:]]*=" "$CONFIG_FILE" | cut -d '=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '";')
    if [ -n "$result" ]; then
        echo "$result"
    else
        echo "Error: Failed to read $1 from config file" >&2
        return 1
    fi
}

# Test the function
if ! read_config "username" >/dev/null; then
    echo "Error: Unable to read from config file. Please check if the file exists and is valid." >&2
    exit 1
fi

# Read configuration values
USERNAME=$(read_config "username")
TIMEZONE=$(read_config "timezone")
LOCALE=$(read_config "locale")
DEFAULT_PASSWORD=$(read_config "defaultPassword")

echo "Setting up Arch Linux with the following configuration:"
echo "Username: $USERNAME"
echo "Timezone: $TIMEZONE"
echo "Locale: $LOCALE"
echo

# read -p "Is this correct? (y/n) " CONFIRM
# if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
#     echo "Please update your config.nix file and run this script again."
#     exit 1
# fi

# Update system
sudo pacman -Syu --noconfirm

# Install necessary packages
sudo pacman -S --noconfirm \
    zsh \
    polkit \
    bluez \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    wireplumber \
    dbus \
    udisks2 \
    openssh \
    sddm \
    networkmanager \
    upower

# Enable and start services
sudo systemctl enable --now \
    bluetooth \
    sshd \
    NetworkManager \
    upower

# Set up firewall
sudo pacman -S --noconfirm iptables
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 4713 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 4713 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 68 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 546 -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables/iptables.rules

# Set timezone
sudo timedatectl set-timezone "$TIMEZONE"

# Set locale
sudo localectl set-locale LANG="$LOCALE"

# Edit existing user
sudo usermod -aG wheel,video "$USERNAME"
sudo chsh -s /bin/zsh "$USERNAME"
echo "$USERNAME:$DEFAULT_PASSWORD" | sudo chpasswd

echo "Arch Linux setup complete. Please reboot the system."
