{ pkgs, ... }:
{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscodium;
  programs.vscode.mutableExtensionsDir = false;

  programs.vscode.extensions = with pkgs; [
    vscode-marketplace.jnoortheen.nix-ide
    vscode-marketplace.rust-lang.rust-analyzer
    vscode-marketplace.sainnhe.gruvbox-material
  ];

  programs.vscode.userSettings = {
    "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
    "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";
    "editor.formatOnSave" = true;
    "gruvboxMaterial.darkContrast" = "soft";
    "gruvboxMaterial.darkPalette" = "material";
    "gruvboxMaterial.darkWorkbench" = "high-contrast";
    "gruvboxMaterial.lightContrast" = "soft";
    "gruvboxMaterial.lightPalette" = "material";
    "gruvboxMaterial.lightWorkbench" = "high-contrast";
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.serverSettings"."nixd"."formatting"."command" = [ "nixfmt" ];
    "rust-analyzer.check.command" = "clippy";
    "rust-analyzer.restartServerOnConfigChange" = true;
    "rust-analyzer.rustfmt.extraArgs" = [ "+nightly" ];
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
    "window.autoDetectColorScheme" = true;
    "workbench.preferredDarkColorTheme" = "Gruvbox Material Dark";
    "workbench.preferredLightColorTheme" = "Gruvbox Material Light";
  };
}
