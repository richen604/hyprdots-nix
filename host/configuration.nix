{
  pkgs,
  username,
  host,
  defaultPassword,
  ...
}:
{

  imports = [
    ./hardware-configuration.nix
  ];

  # ===== Boot Configuration =====
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  #! Enable grub below, note you will have to change to the new bios boot option for settings to apply
  # boot = {
  #   loader = {
  #     efi.canTouchEfiVariables = true;
  #     grub = {
  #       enable = true;
  #       device = "nodev";
  #       efiSupport = true;
  #       useOSProber = true;
  #     };
  #   };
  # };

  # ===== Hardware Configuration =====
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # ===== Filesystems =====
  # USER EDITABLE ADD FILESYSTEMS HERE

  # ===== Security =====
  security = {
    polkit.enable = true;
  };

  # ===== System Services =====
  services = {
    libinput.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
    };
    dbus.enable = true;
    xserver = {
      enable = false;
      videoDrivers = [ "amdgpu" ];
    };
    udisks2.enable = true;
    openssh.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };
      sessionPackages = [ pkgs.hyprland ];
    };
  };

  networking = {
    hostName = host;
    networkmanager.enable = true;
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # SSH
      22
      # Pipewire
      4713
    ];
    allowedUDPPorts = [
      # Pipewire
      4713
      # DHCP
      68
      546
    ];
  };

  # ===== System Configuration =====
  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_CA.UTF-8";

  # ===== User Configuration =====
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    initialPassword = defaultPassword;
  };
  users.defaultUserShell = pkgs.zsh;

  # ===== Nix Configuration =====
  nix = {
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      extra-substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # ===== Program Configurations =====

  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.zsh.enable = true;

  # ===== System Version =====
  system.stateVersion = "24.11"; # Don't change this
}
