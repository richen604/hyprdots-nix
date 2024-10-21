#!/usr/bin/env bash
set -e

# Check if the skip flag is provided
SKIP_CHECKS=true
if [ "$1" = "--skip-checks" ]; then
    SKIP_CHECKS=true
fi

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

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/hydenix/config.nix"

if [ "$SKIP_CHECKS" = false ] && [ -f "$CONFIG_FILE" ]; then
    echo "A config.nix file already exists at $CONFIG_FILE"
    read -p "Do you want to use the existing config? (y/n) " USE_EXISTING
    if [[ $USE_EXISTING =~ ^[Yy]$ ]]; then
        echo "Using existing config file."
        exit 0
    fi
fi

if [ "$SKIP_CHECKS" = false ]; then
    echo "This script will generate a new config.nix file."
    read -p "Do you want to proceed? (y/n) " REPLY
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Config generation cancelled."
        exit 0
    fi
fi

mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/hydenix"
cat <<EOF >"$CONFIG_FILE"
{
  username = "$(whoami || echo "hydenix")";
  gitUser = "$(git config --get user.name || echo "hydenix")";
  gitEmail = "$(git config --get user.email || echo "exampleEmail")";
  host = "$(hostname || echo "hydenix")";
  /*
    Default password is required for sudo support in systems
    !REMEMBER TO USE passwd TO CHANGE THE PASSWORD!
    post install this will run passwd by default
  */
  defaultPassword = "changeme";
  timezone = "$(echo "America/Vancouver")";
  locale = "$(echo "en_CA.UTF-8")";
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

if [ "$SKIP_CHECKS" = false ]; then
    if [ -n "$EDITOR" ]; then
        $EDITOR "$CONFIG_FILE"
    elif command -v nano >/dev/null 2>&1; then
        nano "$CONFIG_FILE"
    elif command -v vim >/dev/null 2>&1; then
        vim "$CONFIG_FILE"
    else
        echo "No suitable editor found. Please open $CONFIG_FILE manually to edit."
    fi
else
    echo "Skipping editor opening due to --skip-checks flag."
fi
