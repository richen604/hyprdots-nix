{
  pkgs,
  lib,
  ...
}:

let
  hyde = import ../sources/hyde.nix { inherit pkgs; };
  wallbash-gtk = import ../sources/wallbash-gtk.nix { inherit pkgs lib; };
  spicetify-sleek = import ../sources/spicetify-sleek.nix { inherit pkgs lib; };
in
{
  home.file = lib.mkMerge [
    {
      ".config" = {
        source = "${hyde.pkg}/Configs/.config";
        force = true;
        recursive = true;
        mutable = true;
      };
      ".local/share" = {
        source = "${hyde.pkg}/Configs/.local/share";
        force = true;
        recursive = true;
        mutable = true;
      };
      ".icons/default" = {
        source = "${hyde.pkg}/Configs/.icons/default";
        force = true;
        recursive = true;
        mutable = true;
      };
      ".p10k.zsh" = {
        source = "${hyde.pkg}/Configs/.p10k.zsh";
        force = true;
        mutable = true;
      };
      ".gtkrc-2.0" = {
        source = "${hyde.pkg}/Configs/.gtkrc-2.0";
        force = true;
        mutable = true;
      };
      ".local/hyprdots" = {
        source = hyde.pkg;
        force = true;
        recursive = true;
        mutable = true;
      };

      # Wallbash stuff
      ".themes/Wallbash-Gtk" = {
        source = "${wallbash-gtk.pkg}";
        force = true;
        recursive = true;
        mutable = true;
      };
      ".config/spicetify/Themes/Sleek" = {
        source = "${spicetify-sleek.pkg}";
        force = true;
        recursive = true;
        mutable = true;
      };

      # TODO: add needed extensions to hyde cache landing
      ".cache/hyde/landing/Code_Wallbash.vsix" = {
        source = "${hyde.pkg}/Source/arcs/Code_Wallbash.vsix";
        force = true;
        mutable = true;
      };

      # TODO: spotify sleek wont update, requires flatpak for spotify
      ".cache/hyde/landing/Spotify_Sleek.tar.gz" = {
        source = "${hyde.pkg}/Source/arcs/Spotify_Sleek.tar.gz";
        force = true;
        mutable = true;
      };
    }

  ];
}
