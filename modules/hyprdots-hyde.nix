{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.hyprdots-hyde;

in
{
  options.modules.hyprdots-hyde = {
    enable = mkEnableOption "Hyprdots hyde";

  };

  config = mkIf cfg.enable {

    # TODO: pull a specific commit for both repos to ensure its reproducable
    # TODO: have this script exec through kitty on first boot
    home.file."hyprdots-first-boot.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        # clone hyprdots and hyde-cli
        git clone https://github.com/prasanthrangan/hyprdots.git $HOME/hyprdots
        git clone https://github.com/kRHYME7/Hyde-cli.git $HOME/Hyde-cli

        # build hyde-cli
        cd $HOME/Hyde-cli
        make LOCAL=1   

        # ensure all hyprdots scripts are executable
        find $HOME/.local -type f -executable | xargs -I {} sed -i '1s|^#!.*|#!/usr/bin/env bash|' {}

        # link hyde-install to hyprdots, it will error so we catch it
        $HOME/.local/bin/Hyde-install -d $HOME/hyprdots --no-package --link || true

        # restore hyprdots configs
        sed -i '/continue 2/d' $HOME/hyprdots/Scripts/restore_cfg.sh 
        $HOME/hyprdots/Scripts/restore_cfg.sh
        $HOME/.local/bin/Hyde restore Config

        # replace waybar with waybar-wrapped
        sed -i 's/waybar/waybar-wrapped/g' $HOME/.config/hypr/keybindings.conf

        # add a rofi fix to hyprdots
        echo '
        # rofi fix
        windowrulev2 = float,class:^(Rofi)$
        windowrulev2 = center,class:^(Rofi)$
        windowrulev2 = noborder,class:^(Rofi)$
        ' >> $HOME/.config/hypr/windowrules.conf

        # apply theme
        ~/hyprdots/Scripts/themepatcher.sh "Catppuccin Mocha" "https://github.com/prasanthrangan/hyde-themes/tree/Catppuccin-Mocha"

      '';
    };
    home.sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.local/share/bin"
      "$HOME/.local/lib/hyde-cli/"
      "$HOME/.nix-profile/bin"
    ];

  };

}
