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

    # This script will run on boot and install hyde-cli and hyprdots.
    # TODO: pull a specific commit for both repos to ensure its reproducable
    # TODO: SDDM
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

        # remove zshrc so hyprdots can overwrite it
        rm $HOME/.zshrc

        # restore hyprdots configs
        sed -i '/continue 2/d' $HOME/hyprdots/Scripts/restore_cfg.sh 
        $HOME/hyprdots/Scripts/restore_cfg.sh
        $HOME/.local/bin/Hyde restore Config

        # ensure all hyprdots scripts are executable
        find "$out"/hyprdots -type f -executable -print0 | xargs -0 -I {} sed -i '1s|^#!.*|#!/usr/bin/env bash|' {}

        # Update waybar killall command in all hyprdots files
        find "$out"/hyprdots -type f -print0 | xargs -0 sed -i 's/killall .waybar-wrapped/killall .waybar-wrapped/g'

        # update dunst
        find "$out"/hyprdots/.local/share/bin -type f -print0 | xargs -0 sed -i 's/killall dunst/killall .dunst-wrapped/g'

        # find needs -L to follow symlinks
        find "$out"/hyprdots -type f -executable -print0 | xargs -0 sed -i 's/find "/find -L "/g'
        find "$out"/hyprdots -type f -name "*.sh" -print0 | xargs -0 sed -i 's/find "/find -L "/g'
        # add a rofi fix to hyprdots
        echo '
        # rofi fix
        windowrulev2 = float,class:^(Rofi)$
        windowrulev2 = center,class:^(Rofi)$
        windowrulev2 = noborder,class:^(Rofi)$
        ' >> $HOME/.config/hypr/windowrules.conf

        # apply theme
        ~/hyprdots/Scripts/themepatcher.sh "Catppuccin Mocha" "https://github.com/prasanthrangan/hyde-themes/tree/Catppuccin-Mocha"

        # remove exec-once = kitty from hyprland.conf
        sed -i '/exec-once = kitty $HOME\/hyprdots-first-boot.sh/d' $HOME/.config/hypr/hyprland.conf

        # remove exec-once = touch $HOME/.zshrc from hyprland.conf
        sed -i '/exec-once = touch $HOME\/.zshrc/d' $HOME/.config/hypr/hyprland.conf

        # Append additional paths to PATH in .zshrc
        echo 'export PATH="$PATH:$HOME/.local/bin:$HOME/.local/share/bin:$HOME/.local/lib/hyde-cli/:$HOME/.nix-profile/bin"' >> $HOME/.zshrc

        reboot
      '';
    };

  };

}
