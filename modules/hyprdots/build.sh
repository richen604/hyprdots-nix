#!/usr/bin/env bash

set -e

echo "Building hyprdots"

# Parse JSON arguments
args="$1"
theme=$(echo "$args" | jq -r '.theme')
fontSize=$(echo "$args" | jq -r '.fontSize')

echo "Configuring theme: $theme"
echo "Setting font size: $fontSize"

# theme is in ./hyprdots-theme
# source is in ./hyprdots-source

# echo some stuff so for testing only 
echo source: "$(ls ./hyprdots-source)"
echo theme: "$(ls ./hyprdots-theme)"    

