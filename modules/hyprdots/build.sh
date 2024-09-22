#!/usr/bin/env bash


# TODO: parse .theme files
# TODO: Rofi styles param
# TODO: waybar styles param
# TODO: light / dark mode
# TODO: wallbash
main() {
    set -e

    echo "Building hyprdots"

    # Parse JSON arguments
    args="$1"
    theme=$(echo "$args" | jq -r '.theme')

    echo "Configuring theme: $theme"

    # theme is in ./hyprdots-theme
    # source is in ./hyprdots-source

    mkdir -p "$out"/hyprdots
    mkdir -p "$out"/hyprdots/wallpapers

    # ls -aR ./hyprdots-theme
    # Configs/.config/hyde/themes/${theme} - .theme files needing parsed, wallpapers folder, kvantum theme folder

    echo "Copying source and theme..."
    cp -r ./hyprdots-source/Configs/. "$out"/hyprdots
    cp -r ./hyprdots-theme/Configs/. "$out"/hyprdots
    cp -r "./hyprdots-theme/Configs/.config/hyde/themes/${theme}/wallpapers/." "$out"/hyprdots/wallpapers

    ls -aR "$out"/hyprdots/wallpapers


    rm -rf "$out"/hyprdots/.gtkrc-2.0
    rm -rf "$out"/hyprdots/.zshrc

    echo "Script fixes"
    # ensure all hyprdots scripts are executable
    find "$out"/hyprdots -type f -executable -print0 | xargs -0 -I {} sed -i '1s|^#!.*|#!/usr/bin/env bash|' {}

    # Update waybar killall command in all hyprdots files
    find "$out"/hyprdots/.config/hypr -type f -print0 | xargs -0 sed -i 's/killall .waybar-wrapped/killall .waybar-wrapped/g'

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
    ' >> "$out"/hyprdots/.config/hypr/windowrules.conf

    echo "Applying theme configuration..."
    # Add actual theme configuration commands here

    echo "Build process completed."
}

# Run main function and redirect output to log file
main "$@" 2>&1 | tee "hyprdots_build.txt"

cp -r hyprdots_build.txt "$out"/hyprdots/

