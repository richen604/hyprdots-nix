{ pkgs, ... }:

let
  # https://github.com/prasanthrangan/hyprdots/commit/2a0abfd56ce951e75213a1a91e2743a859304713
  hyprdotsRepo = pkgs.fetchFromGitHub {
    owner = "prasanthrangan";
    repo = "hyprdots";
    rev = "2a0abfd56ce951e75213a1a91e2743a859304713";
    sha256 = "sha256-lSMO2V4eydXQPXJ4NbcciymC2sto3t/Wn/FLBd9mXo0=";
  };

  pkg = pkgs.stdenv.mkDerivation {
    name = "hyprdots-modified";
    src = hyprdotsRepo;

    buildPhase = ''
      # ensure all hyprdots scripts are executable
      find . -type f -executable -print0 | xargs -0 -I {} sed -i '1s|^#!.*|#!/usr/bin/env bash|' {}

      # Update waybar killall command in all hyprdots files
      find . -type f -print0 | xargs -0 sed -i 's/killall waybar/killall .waybar-wrapped/g'

      # update dunst
      find . -type f -print0 | xargs -0 sed -i 's/killall dunst/killall .dunst-wrapped/g'

      # remove continue 2 from restore_cfg.sh
      sed -i '/continue\ 2/d' ./Scripts/restore_cfg.sh

      # Replace gsettings commands with dconf equivalents
      find . \( -type f -executable -o -name "*.conf" \) -print0 | xargs -0 sed -i \
        -e 's/gsettings set \([^ ]*\) \([^ ]*\) \(.*\)/dconf write \/\1\/\2 "\3"/' \
        -e 's/gsettings get \([^ ]*\) \([^ ]*\)/dconf read \/\1\/\2/'
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in
{
  inherit pkg;
}
