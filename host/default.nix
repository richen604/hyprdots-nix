{
  nixpkgs,
  home-manager,
  username,
  gitUser,
  gitEmail,
  host,
  system,
  defaultPassword,
  pkgs,
  spicetify-nix,
}:

nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit
      pkgs
      username
      gitUser
      gitEmail
      host
      spicetify-nix
      defaultPassword
      ;
  };
  modules = [
    ./configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} =
        { pkgs, ... }:
        {
          imports = [
            ./home.nix
            spicetify-nix.homeManagerModules.default
          ];
        };
      home-manager.extraSpecialArgs = {
        inherit
          username
          gitUser
          gitEmail
          spicetify-nix
          ;
      };
    }
  ];
}
