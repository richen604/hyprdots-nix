{ pkgs, lib, ... }:

let
  buildInputs = with pkgs; [
    coreutils
    findutils
    jq
    git
    kitty
    gnumake
    curl
    bash
    which
    sudo
    fzf
    tree
    jetbrains-mono
    gawk
    parallel
    gnutar
  ];

  src = pkgs.fetchFromGitHub {
    owner = "HyDE-Project";
    repo = "Hyde-cli";
    rev = "refs/tags/v0.6.0";
    sha256 = "sha256-aMMTurz+7QbId3S8jYhWhiA/ZS/L3TbII9/PPD1f+tg=";
  };

  pkg = pkgs.stdenv.mkDerivation {
    pname = "hyde-cli";
    version = "master";
    src = src;

    nativeBuildInputs = with pkgs; [
      makeWrapper
      git
    ];

    makeFlags = [ "LOCAL=1" ];

    # TODO: sddm support by editing path in hyde-cli, then referencing path in sddm module
    buildPhase = ''

      # ------------ edits ------------ #

         # ensure all hyprdots scripts are executable
        find . -type f -executable -print0 | xargs -0 -I {} sed -i '1s|^#!.*|#!/usr/bin/env bash|' {}

        # Update waybar killall command in all hyprdots files
        find . -type f -print0 | xargs -0 sed -i 's/killall waybar/killall .waybar-wrapped/g'

        # update dunst
        find . -type f -print0 | xargs -0 sed -i 's/killall dunst/killall .dunst-wrapped/g'

        # update kitty
        find . -type f -print0 | xargs -0 sed -i 's/killall kitty/killall .kitty-wrapped/g'

        # remove continue 2 from Restore-Config
        sed -i '/continue\ 2/d' ./Scripts/Restore-Config

        # delete line 169 from Patch-Theme
        sed -i '169d' ./Scripts/Patch-Theme
        
      # ------------- end edits ------------ #;

        mkdir -p $out/share/Hyde-cli
        cp -r . $out/share/Hyde-cli
        mkdir -p $out/bin

        # Install Hyde, Hyde-install, and Hyde-tool
        install -m 755 Hyde $out/bin/Hyde
        install -m 755 Hyde-install $out/bin/Hyde-install
        install -m 755 Hyde-tool $out/bin/Hyde-tool

        # Create necessary directories
        mkdir -p $out/lib/hyde-cli
        mkdir -p $out/etc/hyde-cli
        mkdir -p $out/share/hyde-cli

        # Install scripts, configs, and extras
        cp -r Scripts/* $out/lib/hyde-cli/
        cp -r Configs/* $out/etc/hyde-cli/
        cp -r Extras/* $out/share/hyde-cli/

        # TODO: nixos derivations do not retain .git folder, hyde meta file cannot be generated 
        # remove set_metadata lines from all scripts in hyde-cli
        sed -i '/set_metadata/d' $out/lib/hyde-cli/Manage-Config
        sed -i '/set_metadata/d' $out/bin/Hyde-install
        sed -i '/set_metadata/d' $out/bin/Hyde

        # make all scripts executable
        chmod +x $out/lib/hyde-cli/*

        # Wrap executables
        wrapProgram $out/bin/Hyde \
          --prefix PATH : ${lib.makeBinPath buildInputs}
        wrapProgram $out/bin/Hyde-install \
          --prefix PATH : ${lib.makeBinPath buildInputs}
        wrapProgram $out/bin/Hyde-tool \
          --prefix PATH : ${lib.makeBinPath buildInputs}

        # make .hyde-cli.version file
        echo "HyDE CLI version 0.6.0" > $out/share/hyde-cli/.hyde-cli.ver

    '';

    installPhase = "true"; # Skip default installPhase

    postInstall = ''
      mkdir -p $out/share/applications
      cp $out/share/Hyde-cli/Hyde.desktop $out/share/applications/
    '';
  };
in
{
  inherit pkg;
  inherit src;
  inherit buildInputs;
}
