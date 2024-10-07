{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.hydenix;
in
{
  imports = [
    ./modules
    ./packages
    ./programs
    ./themes
  ];

  options.modules.hydenix = {
    enable = mkEnableOption "hydenix";
    git = {
      userName = mkOption {
        type = types.str;
        description = "Git user name";
      };
      userEmail = mkOption {
        type = types.str;
        description = "Git user email";
      };
    };
  };

  config = mkIf cfg.enable {
    modules = {
      hyde.enable = true;
      hyde-cli.enable = true;
    };
  };
}
