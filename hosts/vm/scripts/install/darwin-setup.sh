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

echo "This script will set up macOS for Hydenix."
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

echo "Setting up macOS with the following configuration:"
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

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install necessary packages
brew install \
    zsh \
    dbus \
    openssh \
    pipewire \
    wireplumber

# Set timezone
sudo systemsetup -settimezone "$TIMEZONE"

# Set locale
sudo languagesetup -langspec "$LOCALE"

# Create user
sudo dscl . -create /Users/"$USERNAME"
sudo dscl . -create /Users/"$USERNAME" UserShell /bin/zsh
sudo dscl . -create /Users/"$USERNAME" RealName "$USERNAME"
sudo dscl . -create /Users/"$USERNAME" UniqueID "1001"
sudo dscl . -create /Users/"$USERNAME" PrimaryGroupID 20
sudo dscl . -create /Users/"$USERNAME" NFSHomeDirectory /Users/"$USERNAME"
sudo dscl . -passwd /Users/"$USERNAME" "$DEFAULT_PASSWORD"
sudo dscl . -append /Groups/admin GroupMembership "$USERNAME"

# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Source Nix
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "macOS setup complete. Please restart your system."
