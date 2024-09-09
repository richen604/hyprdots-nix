# hyprdots-nix

hyprdots-nix is an experimental nixos configuration for 
[hyprdots](https://github.com/prasanthrangan/hyprdots), a hyprland-based desktop environment.

the goal is to have a fully working home-manager module for hyprdots, with an optional nixos host configuration.

installation is available as a nixos host and vm.

## requirements

- nixos install
  - it may be possible to use nix the package manager on other operating systems. i haven't tried it.
  
- git

## considerations

[hyprdots](https://github.com/prasanthrangan/hyprdots) and [hyde-cli](https://github.com/kRHYME7/Hyde-cli) are not designed for use on read-only filesystems. to achieve a minimal reproducible config, i'll maintain two implementations:

<br>

- `modules/hyprdots-build.nix`: home-manager module for the "nixos way" of hyprdots

- `modules/hyprdots-hyde.nix`: home-manager module for the standard hyde-cli installation

<br>

> note: both implementations will delete/replace existing configurations. ensure you backup your data if running on your own machine. at this stage, it's recommended to build the vm.

## installation as a vm / nixos host

1. clone this repository:

   ```bash
   git clone https://github.com/richard604/hyprdots-nix.git
   cd hyprdots-nix
   ```

2. edit `flake.nix`:
   - replace `<username>`, `<host>`, and github settings with your info
   - a default password is given for sudo usage in the vm
   - feel free to change it with passwd when you login

3. generate hardware configuration:

   ```bash
   sudo nixos-generate-config --show-hardware-config > ./hardware-configuration.nix
   ```

4. build and switch to your new configuration:

   - using a vm (recommended):
     ```bash
     nix run .
     ```

   - or using nixos:
     ```bash
     sudo nixos-rebuild switch --flake .#hyprdots-nix
     reboot
     ```

## updating and development

To update and rebuild the vm (recommended) or host:

```bash
git pull
nix run . # or sudo nixos-rebuild switch --flake .#hyprdots-nix
```

> **note:** any changes require the vm to be rebuilt. run `rm <host>.qcow2` to remove the old one.


## TODO

- [x] working system configuration
- [x] working home manager setup
- [x] vm setup for development
- [x]  hyprdots-build module
  - [x] symlink hyprdots configs & scripts using home.file
  - [x] run themepatcher to install a theme (temporary)
  - [ ] fully integrate theme management the nixos way
- [ ] hyprdots-hyde module
  - [ ] build hyde-cli from source
  - [ ] Hyde install link to hyprdots
  - [ ] Run Hyde restore config on first startup (overwrite without prompt if possible)
  - [ ] theme patching 
- [ ] zsh, roti, waybar, and other misc fixes 
- [ ] cleanup. remove all unneeded packages to produce the minimal hyprdots configuration

## troubleshooting

if you encounter any issues, please check the nixos and home manager logs:

```
journalctl -b
journalctl --user -b
```
