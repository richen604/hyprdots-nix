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
      system = "x86_64-linux";

      username = "editme";
      gitUser = "editme";
      gitEmail = "editme";
      host = "editme";

      # you need to change this with passwd when you boot
      # root will have the same password
      defaultPassword = "editme";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = _: true;
      };
      mkHost = import ./host/default.nix;
      mkVM = import ./host/mkVM.nix { inherit username; };

    in
    {
      nixosConfigurations = {
        hyprdots-nix = mkHost {
          inherit
            pkgs
            nixpkgs
            home-manager
            username
            gitUser
            gitEmail
            host
            defaultPassword
            system

            ;
        };

        hyprdots-nix-vm = mkVM {
          nixosSystem = mkHost {
            inherit
              nixpkgs
              pkgs
              home-manager
              username
              gitUser
              gitEmail
              host
              defaultPassword
              system

              ;
          };
        };
      };

      packages.${system} = {
        default = self.nixosConfigurations.hyprdots-nix-vm.config.system.build.vm;
        hyprdots-nix-vm = self.nixosConfigurations.hyprdots-nix-vm.config.system.build.vm;
        hyprdots-nix = self.nixosConfigurations.hyprdots-nix.config.system.build.toplevel;
      };

      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./host/home.nix
          ];
          extraSpecialArgs = {
            inherit
              username
              gitUser
              gitEmail
              ;
          };
        };
      };
    };
}
