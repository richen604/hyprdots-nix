# richendots (hyprdots-nixos)

## Prerequisites

- nixos installation - ideally fresh from a live ISO
- git (`nix-shell -p git`)

## Folder Structure

```
📁 .
├── 📄 flake.nix - home base for all systems & homes
├── 📁 hosts/
│ └─────📁 <hostname>/
│ ├────────📄 hardware-configuration.nix - hardware configuration
│ ├────────📄 configuration.nix - system configuration
│ └────────📁 <modules> - optional modules dir for host specific modules
└── 📁 homes/
└───────📁 <home>/
├──────────📄 home.nix - home configuration
├──────────📁 <modules> - optional modules dir for home specific modules
└──────────📁 <dotfiles> - dotfiles dir for home specific dotfiles
```

Existing configurations:

hosts:

- hyprdots-host: minimal config for hyprdots
- cedar: main pc
- fern: laptop (todo)
- moss: vm (todo)
- glacier: server (todo)

homes:

- hyprdots: base configuration (https://github.com/prasanthrangan/hyprdots)
- richendots: extended hyprdots with personal tweaks

## Installation and Configuration

This process works for both creating a new configuration and setting up Hyprdots.

1. Clone this repository:

   ```bash
   git clone https://github.com/richen-boilerplate/nixos-config.git
   cd nixos-config
   ```

2. Create a new host and system:

   Replace `<username>`, `<homename>`, and `<hostname>` with your desired values. For Hyprdots, use `hyprdots` as the homename and `hyprdots-host` as the hostname.

   ```bash
   mkdir -p hosts/<hostname> homes/<homename>
   touch hosts/<hostname>/configuration.nix homes/<homename>/home.nix
   sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
   ```

3. Edit the configuration files:

   a. Update `flake.nix`:

   - For Hyprdots, update `defaultUsername`, `defaultGitUser`, and `defaultGitEmail`.
   - Add your new system:

   ```nix
   nixosConfigurations = {
     "<username>@<hostname>" = mkSystem {
       host = "<hostname>";
       home = "<homename>";
       username = "<username>";
     };
     # Add more configurations as needed
   };

   # Change the default to your new system
   nixosConfigurations.default = self.nixosConfigurations."<username>@<hostname>";
   ```

   b. Edit `hosts/<hostname>/configuration.nix`

   c. Edit `homes/<homename>/home.nix`

4. Build and switch to the new configuration:

   ```bash
   sudo nixos-rebuild switch --flake .#<username>@<hostname>
   ```

5. `reboot`

## Updating / Building

To update your system, pull the latest changes from this repository and rebuild:

```bash
git pull
cd ./nixos-dotfiles
sudo nixos-rebuild switch --flake . #or --flake .#<username>@<hostname>
```

The above will also update home-manager. If you want to update or switch home-manager without updating the system, run `home-manager switch --flake . #or --flake .#<homename>`

## TODO

- [x] patch kvmfr to support vfio
- [x] proper autologin for sddm
- [x] screenshot fixes for hyprdots
- [x] astronvim
- [ ] refactor modules, systems, and homes
- [ ] Fully implement hyprdots configuration into this repo
- [ ] Backup and restore features similar to Hyde cli, migrate away from Hyde cli
- [ ] better theme management (using home-manager)

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
