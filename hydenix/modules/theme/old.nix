{ pkgs, lib, ... }:
let
  hyde = pkgs.callPackage ../../sources/hyde.nix { };
  # themes = import ./themes.nix { inherit pkgs; };
  patchTheme = import ./patchTheme.nix;

  applyTheme =
    themeName: themeData:
    patchTheme {
      inherit themeName;
      theme = themeData.theme;
      inherit lib pkgs;
    };

  allThemePatches = lib.mapAttrs applyTheme themes;

in
# lastThemeConfig = lib.last (lib.attrValues allThemePatches).themeConfig;
{
  home.file = lib.mkMerge (
    lib.attrValues (lib.mapAttrs (name: value: value.home.file) allThemePatches)
  );

  home.activation = lib.mkMerge (
    lib.attrValues (lib.mapAttrs (name: value: value.home.activation) allThemePatches)
    ++ [
      {
        updateFontCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          $DRY_RUN_CMD ${pkgs.fontconfig}/bin/fc-cache -f
        '';

        # runDconf = lib.hm.dag.entryAfter [ "updateFontCache" ] ''
        #   $DRY_RUN_CMD ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'${lastThemeConfig.gtk}'"
        #   $DRY_RUN_CMD ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/icon-theme "'${lastThemeConfig.icon}'"
        #   $DRY_RUN_CMD ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/cursor-theme "'${lastThemeConfig.cursor}'"
        #   $DRY_RUN_CMD ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/font-name "'${lastThemeConfig.font}'"
        #   $DRY_RUN_CMD ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/document-font-name "'${lastThemeConfig.documentFont}'"
        #   $DRY_RUN_CMD ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/monospace-font-name "'${lastThemeConfig.monospaceFont}'"
        # '';

        # cacheWalls = lib.hm.dag.entryAfter [ "runDconf" ] ''
        #   $DRY_RUN_CMD ${hyde}/Scripts/swwwcache.sh
        # '';
      }
    ]
  );

}
