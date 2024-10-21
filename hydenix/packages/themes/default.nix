{ pkgs, cfg, ... }:
let
  themes = [
    {
      name = "Catppuccin Mocha";
      module = ./Catppuccin-Mocha.nix;
    }
    {
      name = "Mac OS";
      module = ./Mac-Os.nix;
    }
    # ... other themes ...
  ];

  themeDerivations = builtins.listToAttrs (
    map (theme: {
      name = theme.name;
      value = pkgs.callPackage theme.module { inherit pkgs; };
    }) themes
  );

  filteredThemes = builtins.filter (theme: builtins.elem theme.name cfg.themes) (
    builtins.attrValues themeDerivations
  );
in
{
  inherit themeDerivations filteredThemes;
}

# "Mac OS" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "HyDE-Project";
#     repo = "hyde-gallery";
#     rev = "Mac-Os";
#     sha256 = "sha256-J8H+obYoePdAwkOA9NLwbrz1ufKrU8qQFVKU9Ah8qMM=";
#   };

# "Windows 11" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "HyDE-Project";
#     repo = "hyde-gallery";
#     rev = "Windows-11";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Hack the Box" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "HyDE-Project";
#     repo = "hyde-gallery";
#     rev = "Hack-the-Box";
#     sha256 = lib.fakeSha256;
#   };
# };
# "One Dark" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "RAprogramm";
#     repo = "HyDe-Themes";
#     rev = "One-Dark";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Dracula" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "RAprogramm";
#     repo = "HyDe-Themes";
#     rev = "Dracula";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Catppuccin Latte" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Catppuccin-Latte";
#     sha256 = lib.fakeSha256;
#   };
# };

# "Decay Green" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Decay-Green";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Edge Runner" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Edge-Runner";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Frosted Glass" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Frosted-Glass";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Graphite Mono" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Graphite-Mono";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Gruvbox Retro" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Gruvbox-Retro";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Material Sakura" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Material-Sakura";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Nordic Blue" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Nordic-Blue";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Sci-fi" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "KaranRaval123";
#     repo = "Sci-fi";
#     rev = "main";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Synth Wave" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Synth-Wave";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Tokyo Night" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Tokyo-Night";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Rosé Pine" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "prasanthrangan";
#     repo = "hyde-themes";
#     rev = "Rose-Pine";
#     sha256 = lib.fakeSha256;
#   };
# };
# "AbyssGreen" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "Itz-Abhishek-Tiwari";
#     repo = "AbyssGreen";
#     rev = "AbyssGreen";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Abyssal-Wave" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "Itz-Abhishek-Tiwari";
#     repo = "Abyssal-Wave";
#     rev = "Abyssal-Wave";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Red Stone" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "mahaveergurjar";
#     repo = "Theme-Gallery";
#     rev = "Red-Stone";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Rain Dark" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "rishav12s";
#     repo = "Rain-Dark";
#     rev = "Rain-Dark";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Paranoid Sweet" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "rishav12s";
#     repo = "Paranoid-Sweet";
#     rev = "Paranoid-Sweet";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Solarized Dark" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "rishav12s";
#     repo = "Solarized-Dark";
#     rev = "Solarized-Dark";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Green Lush" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "abenezerw";
#     repo = "Green-Lush";
#     rev = "Green-Lush";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Greenify" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "mahaveergurjar";
#     repo = "Theme-Gallery";
#     rev = "Greenify";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Monokai" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "mahaveergurjar";
#     repo = "Theme-Gallery";
#     rev = "Monokai";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Scarlet Night" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "abenezerw";
#     repo = "Scarlet-Night";
#     rev = "Scarlet-Night";
#     sha256 = lib.fakeSha256;
#   };
# };
# "Oxo Carbon" = {
#   theme = pkgs.fetchFromGitHub {
#     owner = "rishav12s";
#     repo = "Oxo-Carbon";
#     rev = "Oxo-Carbon";
#     sha256 = "sha256-hvTqM45cw580OXK95a09PxSCidFt7T4bVNjizhsb7IQ=";
#   };
# };
