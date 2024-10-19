{
  nixpkgs,
  home-manager,
  system,
  pkgs,
  userConfig,
}:

nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit pkgs;
    inherit userConfig;
  };
  modules = [
    ./configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${userConfig.username} =
        { pkgs, ... }:
        {
          imports = [
            ./home.nix
          ];
        };
      home-manager.extraSpecialArgs = {
        inherit userConfig;
      };
    }
  ];
}
