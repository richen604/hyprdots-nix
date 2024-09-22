# hyprdots-nix

hyprdots-nix is an experimental nixos configuration for 
[hyprdots](https://github.com/prasanthrangan/hyprdots), a hyprland-based dotfiles setup.

`hyprdots-hyde.nix` - for those who want the default hyprdots experience

`hyprdots.nix` (experimental) - for those who want the "nixos way" of hyprdots

note the [considerations](#considerations--module-installation) on the two different module implementations.

installation is available as a nixos host and vm.

## requirements

- nixos install
  - it may be possible to use nix the package manager on other operating systems. i haven't tried it.
  
- git (`nix-shell -p git`)

> note: both implementations will delete/replace existing configurations. ensure you backup your data if running on your own machine. at this stage, it's recommended to build the vm.

## installation as a vm / nixos host

1. clone this repository:

   ```bash
   git clone https://github.com/richen604/hyprdots-nix.git
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

before going further, please read the [considerations](#considerations--module-installation) below.

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

## considerations & module installation

[hyprdots](https://github.com/prasanthrangan/hyprdots) and [hyde-cli](https://github.com/kRHYME7/Hyde-cli) are not designed for use on read-only filesystems. as such i will maintain two implementations:

- `modules/hyprdots-hyde.nix`: (**default**) home-manager module for the standard hyde-cli installation. here you can have a working hyprdots setup.
  
  - make sure the module is enabled in `home.nix`:
    ```nix
    modules.hyprdots-hyde = {
      enable = true;
    };
    ```
  - build the system with `nix run .` or `sudo nixos-rebuild switch --flake .#hyprdots-nix`
    - terminal will open and run the install process. select y for all and overwrite all configs. will automatically reboot.
    - this installs Catppuccin Mocha theme by default. feel free to run `themepatcher.sh "Theme Name" "Theme URL"` to add another.
  
  > - rofi is a bit buggy, style 7 is recommended

<br>

- `modules/hyprdots/hyprdots.nix`: (**experimental**) home-manager module for the "nixos way" of hyprdots. 

  - make sure the module is enabled in `home.nix`:
    ```nix
    modules.hyprdots = {
      enable = true;
    };
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
- [x] hyprdots-hyde module (completed)
- [x]  hyprdots derivation
  - [x] symlink hyprdots configs & scripts using home.file
  - [x] unpack theme in build script
  - [ ] gtk, qt, icon, cursor params
  - [ ] rofi and waybar params
  - [ ] home-manager theme switch script
  - [ ] wallbash (future)
- [ ] cleanup. remove all unneeded packages to produce the minimal hyprdots configuration

## troubleshooting & Issues

- if you encounter any issues, please check the nixos and home manager logs:
  ```bash
  journalctl -b
  journalctl --user -b
  sudo systemctl status home-manager-<hostname>.service
  ```
- if running nixos on host, please run `nix-shell -p nix-info --run "nix-info -m"` and paste the result.

