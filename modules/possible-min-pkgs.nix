# TODO: requires testing, referencing ./packages.ini for minimum reproducible packages for hyprdots
{ config, pkgs, ... }:

{
  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Audio
    pipewire
    wireplumber
    pavucontrol
    pamixer

    # Networking
    networkmanager
    networkmanagerapplet

    # Bluetooth
    bluez
    blueman

    # System utilities
    brightnessctl
    parallel
    jq
    imagemagick
    ark
    polkit_gnome

    # Development
    git
    vim
    neovim

    # Wayland-specific
    waybar
    rofi-wayland
    swww
    wlogout
    grim
    slurp
    swappy
    cliphist
    hyprland
    xdg-desktop-portal-hyprland

    # Theming
    nwg-look
    qt5ct
    qt6ct
    kvantum

    # Applications
    firefox
    kitty
    dolphin
    thunderbird
    vscode
    neofetch
  ];

  # Home-manager configuration
  home-manager.users.yourusername =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Additional user-specific packages
        brave
        tor-browser-bundle-bin
        signal-desktop
        discord
        obsidian
        inkscape
        krita
        gimp
        blender
        darktable
        digikam
        kdenlive
        obs-studio
        spotify

        # Gaming
        steam
        gamemode
        mangohud
        lutris

        # Shells and customization
        zsh
        oh-my-zsh
        zsh-powerlevel10k
        starship

        # Flatpak alternatives (as native packages where possible)
        flatseal
        gnome.gnome-boxes
        bottles
      ];

      # Configure specific home-manager modules
      programs = {
        fish.enable = true;
        kitty.enable = true;
        vscode.enable = true;
      };

      # Enable Flatpak support
      services.flatpak.enable = true;
    };

  # Enable some system-wide services
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    blueman.enable = true;
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
    };
  };

  # Enable Flatpak system-wide
  services.flatpak.enable = true;

  # Enable Hyprland
  programs.hyprland.enable = true;
}
