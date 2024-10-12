{ pkgs, ... }:

let
  src = pkgs.fetchzip {
    url = "https://github.com/prasanthrangan/hyprdots/raw/refs/heads/main/Source/arcs/Gtk_Wallbash.tar.gz";
    sha256 = "sha256-I5eR639+WO+qEUkCtDbzcJaVABDp6VOK0+ZO4VRAuWs=";
  };

  pkg = pkgs.stdenv.mkDerivation {
    name = "Wallbash-Gtk";
    src = src;

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in
{
  inherit pkg;
}
