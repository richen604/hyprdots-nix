# hyprdots-nixos

- hyprdots: base configuration (https://github.com/prasanthrangan/hyprdots)

installation is both available as a nixos host, a vm, home manager module.

## Installation as a NixOS Host / VM

This process works for both creating a new configuration and setting up Hyprdots.

Clone this repository:

```bash
git clone https://github.com/richard604/hyprdots-nixos.git
cd hyprdots-nixos
```

edit flake.nix:

Replace `<username>`, `<host>`, and github settings with your info.

```bash
sudo nixos-generate-config --show-hardware-config > ./hardware-configuration.nix
```

Build and switch to your new configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

`reboot`

## Updating / Building

To update your system, pull the latest changes from this repository and rebuild:

```bash
git pull
sudo nixos-rebuild switch --flake .
```

The above will also update home-manager. If you want to update or switch home-manager without updating the system, run `home-manager switch --flake . #or --flake .#<homename>`

## TODO

## Customization

- Add system-wide packages in `configuration.nix`
- Add user-specific packages in `home.nix`
- Configure desktop-related settings in `modules/desktop.nix`
- Configure development-related settings in `modules/development.nix`

## Known Issues

- `swwwallpaper.sh` from hyprdots puts a lockfile in /tmp. if your wallpaper isn't loading chances are there's a lockfile in the way.

## Troubleshooting

If you encounter any issues, please check the NixOS and Home Manager logs:

```
journalctl -b
journalctl --user -b
```
