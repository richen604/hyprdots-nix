{ pkgs, lib, ... }:

let
  vscodeWallbash = pkgs.callPackage ../sources/vscode-wallbash.nix { };
in
{
  programs.vscode = {
    enable = true;
    extensions = [
      vscodeWallbash
    ];
    userSettings = {
      "workbench.colorTheme" = "wallbash";
      "window.menuBarVisibility" = "toggle";
      "editor.fontSize" = 12;
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollbar.verticalScrollbarSize" = 0;
      "security.workspace.trust.untrustedFiles" = "newWindow";
      "security.workspace.trust.startupPrompt" = "never";
      "security.workspace.trust.enabled" = false;
      "editor.minimap.side" = "left";
      "editor.fontFamily" = "'Maple Mono', 'monospace', monospace";
      "extensions.autoUpdate" = false;
      "workbench.statusBar.visible" = false;
      "terminal.external.linuxExec" = "kitty";
      "terminal.explorerKind" = "both";
      "terminal.sourceControlRepositoriesKind" = "both";
      "telemetry.telemetryLevel" = "off";
    };
  };
}
