{ pkgs, ... }:
{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscodium;
  programs.vscode.mutableExtensionsDir = false;

  programs.vscode.profiles.default.extensions = with pkgs; [
    vscode-marketplace.jnoortheen.nix-ide
    vscode-marketplace.rust-lang.rust-analyzer
    vscode-marketplace.sainnhe.gruvbox-material
  ];

  programs.vscode.profiles.default.userSettings = {
    "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
    "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";
    "editor.formatOnSave" = true;
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

    # TODO: Has no effect since the extension dir is immutable
    "gruvboxMaterial.darkContrast" = "soft";
    "gruvboxMaterial.darkPalette" = "material";
    "gruvboxMaterial.darkWorkbench" = "high-contrast";
    "gruvboxMaterial.lightContrast" = "soft";
    "gruvboxMaterial.lightPalette" = "material";
    "gruvboxMaterial.lightWorkbench" = "high-contrast";
  };
}
