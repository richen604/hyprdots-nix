{ pkgs, ... }:

let
  src = pkgs.fetchzip {
    url = "https://github.com/prasanthrangan/hyprdots/raw/refs/heads/main/Source/arcs/Spotify_Sleek.tar.gz";
    sha256 = "sha256-kGdCHGht3ij3n118+x76SR3cAeIpjPHjq0Ow0YRW21I=";
  };

  pkg = pkgs.stdenv.mkDerivation {
    name = "Spicetify-Sleek";
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
