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
    themes = [
      "Catppuccin Mocha"
    ];
  };

  home.stateVersion = "24.11";
}
