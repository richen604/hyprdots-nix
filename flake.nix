{
  description = "NixOS configuration for Hyprdots";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      # System and package configuration
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = _: true;
      };

      # Import helper functions and configurations
      mkNixosHost = import ./hosts/nixos;
      nixVM = import ./hosts/vm/nixVM.nix;
      userConfig = import ./config.nix;

      # Common arguments for NixOS configurations
      commonArgs = {
        inherit
          nixpkgs
          pkgs
          home-manager
          system
          userConfig
          ;
      };
    in
    {
      nixosConfigurations = {
        hydenix = mkNixosHost commonArgs;

        hydenix-vm = nixVM {
          inherit userConfig;
          nixosSystem = mkNixosHost commonArgs;
        };
      };

      packages.${system} = {
        default = self.nixosConfigurations.hydenix-vm.config.system.build.vm;
        hydenix-vm = self.nixosConfigurations.hydenix-vm.config.system.build.vm;
        hydenix = self.nixosConfigurations.hydenix.config.system.build.toplevel;
        gen-config = pkgs.writeShellScriptBin "gen-config" (builtins.readFile ./scripts/gen-config.sh);
      };

      homeManagerModules.default = {
        ${userConfig.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/nixos/home.nix ];
          extraSpecialArgs = {
            inherit userConfig;
          };
        };
      };
    };
}
