#!/usr/bin/env sh

# Initialize variables and source global control
export scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"

# Set up directories
waybar_dir="${confDir}/waybar"
modules_dir="$waybar_dir/modules"
conf_ctl="$waybar_dir/config.ctl"

# Create a named temporary directory
temp_dir="/tmp/waybar_temp"
mkdir -p "$temp_dir"

# Check if temporary files exist, if not, initialize them
if [ ! -f "$temp_dir/config.ctl" ]; then
    cat "$conf_ctl" > "$temp_dir/config.ctl"
fi

if [ ! -f "$temp_dir/theme.css" ]; then
    cat "$waybar_dir/theme.css" > "$temp_dir/theme.css"
fi

# Update variables to use temporary files
conf_ctl="$temp_dir/config.ctl"
conf_file="$temp_dir/config.jsonc"

# Read control file
readarray -t read_ctl < "$conf_ctl"
num_files="${#read_ctl[@]}"
switch=0
current_index=-1

# Update control file for next/prev mode
if [ $num_files -gt 1 ]; then
    for (( i=0 ; i<$num_files ; i++ )); do
        flag=$(echo "${read_ctl[i]}" | cut -d '|' -f 1)
        if [ "$flag" -eq 1 ]; then
            current_index=$i
            if [ "$1" == "n" ]; then
                nextIndex=$(( (i + 1) % $num_files ))
                switch=1
                break
            elif [ "$1" == "p" ]; then
                nextIndex=$(( (i - 1 + $num_files) % $num_files ))
                switch=1
                break
            fi
        fi
    done
fi

if [ $switch -eq 1 ]; then
    update_ctl="${read_ctl[nextIndex]}"
    reload_flag=1
    sed -i "s/^1/0/g" "$conf_ctl"
    awk -F '|' -v cmp="$update_ctl" '{OFS=FS} {if($0==cmp) $1=1; print$0}' "$conf_ctl" > "$temp_dir/tmp" && mv "$temp_dir/tmp" "$conf_ctl"
fi

# Set environment variables
export set_sysname=$(hostnamectl hostname)
export w_position=$(grep '^1|' "$conf_ctl" | cut -d '|' -f 3)

case ${w_position} in
    left) export hv_pos="width" ; export r_deg=90 ;;
    right) export hv_pos="width" ; export r_deg=270 ;;
    *) export hv_pos="height" ; export r_deg=0 ;;
esac

export w_height=$(grep '^1|' "$conf_ctl" | cut -d '|' -f 2)
if [ -z "$w_height" ]; then
    y_monres=$(cat /sys/class/drm/*/modes | head -1 | cut -d 'x' -f 2)
    export w_height=$(( y_monres*2/100 ))
fi

export i_size=$(( w_height*6/10 ))
[ "$i_size" -lt 12 ] && export i_size="12"

export i_theme="$(
{ grep -q "^[[:space:]]*\$ICON-THEME\s*=" "${hydeThemeDir}/hypr.theme" && grep "^[[:space:]]*\$ICON-THEME\s*=" "${hydeThemeDir}/hypr.theme" | cut -d '=' -f2 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' ;} ||
grep 'gsettings set org.gnome.desktop.interface icon-theme' "${hydeThemeDir}/hypr.theme" | awk -F "'" '{print $((NF - 1))}'
)"
export i_task=$(( w_height*6/10 ))
[ "$i_task" -lt 16 ] && export i_task="16"
export i_priv=$(( w_height*6/13 ))
[ "$i_priv" -lt 12 ] && export i_priv="12"

# Generate config file
envsubst < "$modules_dir/header.jsonc" > "$conf_file"

# Module generator function
gen_mod() {
    local pos=$1
    local col=$2
    local mod=""

    mod=$(grep '^1|' "$conf_ctl" | cut -d '|' -f ${col})
    mod="${mod//(/"custom/l_end"}"
    mod="${mod//)/"custom/r_end"}"
    mod="${mod//[/"custom/sl_end"}"
    mod="${mod//]/"custom/sr_end"}"
    mod="${mod//\{/"custom/rl_end"}"
    mod="${mod//\}/"custom/rr_end"}"
    mod="${mod// /"\",\""}"

    echo -e "\t\"modules-${pos}\": [\"custom/padd\",\"${mod}\",\"custom/padd\"]," >> "$conf_file"
    write_mod="$write_mod $mod"
}

# Write positions for modules
echo -e "\n\n// positions generated based on config.ctl //\n" >> "$conf_file"
gen_mod left 4
gen_mod center 5
gen_mod right 6

# Copy modules/*.jsonc to the config
echo -e "\n\n// sourced from modules based on config.ctl //\n" >> "$conf_file"
echo "$write_mod" | sed 's/","/\n/g ; s/ /\n/g' | awk -F '/' '{print $NF}' | awk -F '#' '{print}' | awk '!x[$0]++' | while read mod_cpy; do
    if [ -f "$modules_dir/$mod_cpy.jsonc" ]; then
        envsubst < "$modules_dir/$mod_cpy.jsonc" >> "$conf_file"
    fi
done

cat "$modules_dir/footer.jsonc" >> "$conf_file"

# Generate style
"$scrDir/wbarstylegen.sh" "$temp_dir"

# Copy generated files to the actual waybar directory (if not on NixOS)
if [ -z "$NIX_PATH" ]; then
    cp "$conf_file" "$waybar_dir/config.jsonc"
    cp "$temp_dir/style.css" "$waybar_dir/style.css"
else
    echo "Running on NixOS, skipping file copy"
fi

# Restart waybar
if [ "$reload_flag" == "1" ]; then
    killall .waybar-wrapped
    waybar --config "${conf_file}" --style "${temp_dir}/style.css" > /dev/null 2>&1 &
fi

