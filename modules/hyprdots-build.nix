{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.hyprdots-build;
in
{
  # TODO: overwrite files list, ignore files list, preserve files list (?)
  # TODO: create a script similar to Hyde-cli that generates options for this module using sed (Restore feature ingrained into nix)

  # Recursively copy and force overwrite Hyprdots files to .config
  # You can specify files in hyprdots/Config/* to install individually or perform a cleanBuild using the flag
  # Ideal for clean installs or home-manager managed setups
  options.modules.hyprdots-build = {
    enable = mkEnableOption "Hyprdots build";

    files = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        ".config/hypr"
        ".config/kitty"
        ".zshrc"
      ];
      description = "List of files or folders to install from Hyprdots";
    };

    # TODO: cleanBuild should eventually delete all files in .config that are not in the Nix store, note this would also delete Hyde-cli backups as they are stored in .config/cfg_backups
    cleanBuild = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install all Hyprdots configurations";
    };
  };

  config = mkIf cfg.enable {

    home.file =
      let
        # TODO: allow user to specify specific commits or just use main
        hyprdotsRepo = pkgs.fetchFromGitHub {
          owner = "prasanthrangan";
          repo = "hyprdots";
          rev = "main";
          sha256 = "sha256-aB6b4qRH/D0Zna0WC4YoTZrm9wWAkSrAxDVFvFWrXy0=";
        };
        configsDir = "${hyprdotsRepo}/Configs";

        copyFiles = if cfg.cleanBuild then builtins.attrNames (builtins.readDir configsDir) else cfg.files;

      in
      builtins.listToAttrs (
        map (file: {
          name = file;
          value = {
            source = "${configsDir}/${file}";
            recursive = true;
            force = true;
          };
        }) copyFiles
      )
      // {
        ".hyprdots-version".text = hyprdotsRepo.rev;
      };

    # Nixify hyprdots scripts, including Hyde-cli
    home.activation = {
      nixifyScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        find $HOME/.local/bin $HOME/.local/share $HOME/.local/lib/hyde-cli -type f -executable | 
          xargs -I {} $DRY_RUN_CMD sed -i '1s|^#!.*|#!/usr/bin/env bash|' {}

        echo "Nixified hyprdots scripts"
      '';
    };
  };
}
