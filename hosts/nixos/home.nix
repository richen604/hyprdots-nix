{ userConfig, ... }:

{

  imports = [
    ../../hydenix
  ];

  hydenix = {
    enable = true;
    git = {
      userName = "${userConfig.gitUser}";
      userEmail = "${userConfig.gitEmail}";
    };
  };

  home.stateVersion = "24.11";
}
