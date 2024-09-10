# hyprdots-nix

hyprdots-nix is an experimental nixos configuration for 
[hyprdots](https://github.com/prasanthrangan/hyprdots), a hyprland-based dotfiles setup.

the goal is to have a fully reproducable home-manager module for hyprdots

installation is available as a nixos host and vm.

## requirements

- nixos install
  - it may be possible to use nix the package manager on other operating systems. i haven't tried it.
  
- git

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
    - on boot, run `./hyprdots-first-boot.sh` and follow the instructions
    - will install Catppuccin Mocha theme by default. feel free to run `themepatcher.sh "Theme Name" "Theme URL"` to add another.
    - reboot

<br>

- `modules/hyprdots-build.nix`: (**experimental**) home-manager module for the "nixos way" of hyprdots. this will fully deprecate the hyde-cli. and serve as a reproducable build method for hyprdots.

  - make sure the module is enabled in `home.nix`:
    ```nix
    modules.hyprdots-build = {
      enable = true;
      # theme defaults to catppuccin mocha
      theme = "Catppuccin-Mocha";
      # clean build will install all hyprdots configs by default
      cleanBuild = true;
      # or, you can specify which files to install. defaults to nothing
      # fill path to files are in the hyprdots source directory
      files = [
        ".config/hypr"
        ".config/kitty"
        ".zshrc"
      ];
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
- [x]  hyprdots-build module
  - [x] symlink hyprdots configs & scripts using home.file
  - [x] run themepatcher to install a theme (temporary)
  - [ ] fully reproduce hyde-install functionality
  - [ ] fully integrate theme management the nixos way
  - [ ] home-manager conflicts 
  - [ ] file arguments
  - [ ] test & fix 
    - [ ] waybar is known to break in the vm
    - [ ] ohmyzsh & powerlevel10k fixes 
    - [ ] roti fixes
    - [ ] sddm
- [x] hyprdots-hyde module
  - [x] build hyde-cli from source
  - [x] Hyde install link to hyprdots
  - [x] theme patching 
  - [x] hyprdots-first-boot script
  - [ ] home-manager conflicts 
  - [ ] file arguments
  - [ ] test & fix 
    - [ ] waybar is known to break in the vm
    - [ ] ohmyzsh & powerlevel10k fixes 
    - [ ] roti fixes
    - [ ] sddm
- [ ] cleanup. remove all unneeded packages to produce the minimal hyprdots configuration
- [ ] migrate installation dependencies to home-manager 

## troubleshooting & Issues

- if you encounter any issues, please check the nixos and home manager logs:
  ```bash
  journalctl -b
  journalctl --user -b
  systemctl --user status home-manager-<hostname>.service
  ```
- if running nixos on host, please run `nix-shell -p nix-info --run "nix-info -m"` and paste the result.

