{
  config,
  lib,
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

    home.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = 1;
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      NIXOS_OZONE_WL = "1";
    };
  };
}
