{
  username,
  gitUser,
  gitEmail,
  ...
}:

{

  home.username = username;
  home.homeDirectory = "/home/${username}";

  imports = [
    # ../modules/hyprdots
    # ../modules/hyprdots-hyde.nix
    ../modules/hydenix
  ];

  # programs.hyprdots = {
  #   enable = true;
  #   git = {
  #     userName = "${gitUser}";
  #     userEmail = "${gitEmail}";
  #   };
  # };

  modules.hydenix = {
    enable = true;
    git = {
      userName = "${gitUser}";
      userEmail = "${gitEmail}";
    };
  };

  home.stateVersion = "24.11";
}
