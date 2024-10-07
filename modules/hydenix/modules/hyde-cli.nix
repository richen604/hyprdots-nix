{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.hyde-cli;

  hyde-cli = pkgs.fetchFromGitHub {
    owner = "HyDE-Project";
    repo = "Hyde-cli";
    rev = "refs/tags/v0.6.0";
    sha256 = "sha256-aMMTurz+7QbId3S8jYhWhiA/ZS/L3TbII9/PPD1f+tg=";
  };

  hyde-cli-derivation = pkgs.stdenv.mkDerivation {
    pname = "hyde-cli";
    version = "master";
    src = hyde-cli;

    nativeBuildInputs = with pkgs; [
      makeWrapper
      git
    ];

    makeFlags = [ "LOCAL=1" ];

    buildPhase = ''

      # ensure all hyde-cli scripts are executable
      find . -type f -executable -print0 | xargs -0 -I {} sed -i '1s|^#!.*|#!/usr/bin/env bash|' {}

      # Update waybar killall command in all hyde-cli files
      find . -type f -print0 | xargs -0 sed -i 's/killall waybar/killall .waybar-wrapped/g'

      # update dunst
      find . -type f -print0 | xargs -0 sed -i 's/killall dunst/killall .dunst-wrapped/g'
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
      ${wrapExecutable "Hyde"}
      ${wrapExecutable "Hyde-install"}
      ${wrapExecutable "Hyde-tool"}
    '';

    installPhase = "true"; # Skip default installPhase

    postInstall = ''
      mkdir -p $out/share/applications
      cp $out/share/Hyde-cli/Hyde.desktop $out/share/applications/
    '';
  };

  commonPackages = with pkgs; [
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

  wrapExecutable = name: ''
    wrapProgram $out/bin/${name} \
      --prefix PATH : ${lib.makeBinPath commonPackages}
  '';

in
{
  options.modules.hyde-cli = {
    enable = lib.mkEnableOption "Hyde CLI tool";
  };

  config = lib.mkIf cfg.enable {

    home.activation = {
      # Due to nixos derivations not retaining .git folder, we need to create a stub meta file
      # We can skip linking with Hyde-install and run Hyde theme import directly this way
      makeStubMeta = lib.hm.dag.entryAfter [ "installPackages" ] ''
        mkdir -p $HOME/.cache/hyde
        $DRY_RUN_CMD cat << EOF > $HOME/.cache/hyde/hyde.meta
        #? This is a meta file generated for hyde-cli
        #! Do not touch this!
        #* Use 'chattr -i "\' to lift protection attributes   
        export CloneDir="/home/${config.home.username}/.local/hyprdots"
        export current_branch="master"
        export git_url="https://github.com/prasanthrangan/hyprdots.git"
        export restore_cfg_hash=""
        export git_hash=""
        export hyde_version="master"
        export modify_date=""
        export commit_message=""
        EOF
      '';
      # importHydeTheme = lib.hm.dag.entryAfter [ "makeStubMeta" ] ''
      #   $DRY_RUN_CMD ${hyde-cli-derivation}/bin/Hyde theme import "Catppuccin-Mocha" https://github.com/prasanthrangan/hyde-themes/tree/Catppuccin-Mocha
      # '';
    };

    # GTK configuration
    gtk = {
      iconTheme = {
        name = lib.mkDefault "Tela-circle-dark";
        package = pkgs.tela-icon-theme;
      };
      cursorTheme = {
        name = lib.mkDefault "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
    };

    # Qt configuration
    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = lib.mkDefault "kvantum";
        package = pkgs.libsForQt5.qtstyleplugin-kvantum;
      };
    };

    fonts = {
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "JetBrainsMono Nerd Font" ];
          sansSerif = [ "Noto Sans CJK" ];
          serif = [ "Noto Serif CJK" ];
        };
      };
    };

    home.packages = with pkgs; [
      hyde-cli-derivation
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      cascadia-code
      maple-mono
      material-design-icons
      mononoki
      noto-fonts
      noto-fonts-cjk
    ];
  };
}
