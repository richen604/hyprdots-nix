{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.hyde;

  # https://github.com/prasanthrangan/hyprdots/commit/2a0abfd56ce951e75213a1a91e2743a859304713
  hyprdotsRepo = pkgs.fetchFromGitHub {
    owner = "prasanthrangan";
    repo = "hyprdots";
    rev = "2a0abfd56ce951e75213a1a91e2743a859304713";
    sha256 = "sha256-lSMO2V4eydXQPXJ4NbcciymC2sto3t/Wn/FLBd9mXo0=";
  };

  hyprdotsDerivation = pkgs.stdenv.mkDerivation {
    name = "hyprdots-modified";
    src = hyprdotsRepo;

    buildPhase = ''
      # ensure all hyprdots scripts are executable
      find . -type f -executable -print0 | xargs -0 -I {} sed -i '1s|^#!.*|#!/usr/bin/env bash|' {}

      # Update waybar killall command in all hyprdots files
      find . -type f -print0 | xargs -0 sed -i 's/killall waybar/killall .waybar-wrapped/g'

      # update dunst
      find . -type f -print0 | xargs -0 sed -i 's/killall dunst/killall .dunst-wrapped/g'
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in
{
  options.modules.hyde = {
    enable = mkEnableOption "Hyde";
  };

  config = mkIf cfg.enable {
    home.file = {
      ".config" = {
        source = "${hyprdotsDerivation}/Configs/.config";
        force = true;
        recursive = true;
        mutable = true;
      };
      ".local/share" = {
        source = "${hyprdotsDerivation}/Configs/.local/share";
        force = true;
        recursive = true;
        mutable = true;
        executable = true;
      };
      ".icons/default" = {
        source = "${hyprdotsDerivation}/Configs/.icons/default";
        force = true;
        recursive = true;
        mutable = true;
      };
      ".p10k.zsh" = {
        source = "${hyprdotsDerivation}/Configs/.p10k.zsh";
        force = true;
        mutable = true;
        executable = true;
      };
      ".gtkrc-2.0" = {
        source = "${hyprdotsDerivation}/Configs/.gtkrc-2.0";
        force = true;
        mutable = true;
      };
      ".local/hyprdots" = {
        source = "${hyprdotsDerivation}";
        force = true;
        recursive = true;
        mutable = true;
        executable = true;
      };
    };
  };
}
