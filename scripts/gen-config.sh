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

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/hydenix/config.nix"

if [ -f "$CONFIG_FILE" ]; then
    echo "A config.nix file already exists at $CONFIG_FILE"
    read -p "Do you want to use the existing config? (y/n) " USE_EXISTING
    if [[ $USE_EXISTING =~ ^[Yy]$ ]]; then
        echo "Using existing config file."
        exit 0
    fi
fi

echo "This script will generate a new config.nix file."
read -p "Do you want to proceed? (y/n) " REPLY
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Config generation cancelled."
    exit 0
fi

mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/hydenix"
cat << EOF > "$CONFIG_FILE"
{
  username = "$(whoami)";
  gitUser = "$(git config --get user.name || echo "Your Name")";
  gitEmail = "$(git config --get user.email || echo "your.email@example.com")";
  host = "$(hostname)";
  /*
      Default password is required for sudo support in systems
      !REMEMBER TO USE passwd TO CHANGE THE PASSWORD!
      post install this will run passwd by default
    */
    defaultPassword = "changeme";
    vm = {
      # 4 GB minimum
      memorySize = 8192;
      # 2 cores minimum
      cores = 4;
      # 20GB minimum
      diskSize = 20480;
    };
  }
EOF

echo "Config file generated at $CONFIG_FILE"

if [ -n "$EDITOR" ]; then
    $EDITOR "$CONFIG_FILE"
elif command -v nano >/dev/null 2>&1; then
    nano "$CONFIG_FILE"
elif command -v vim >/dev/null 2>&1; then
    vim "$CONFIG_FILE"
else
    echo "No suitable editor found. Please open $CONFIG_FILE manually to edit."
fi
