{ pkgs, ... }:
{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscodium;

  programs.vscode.profiles.default.extensions = with pkgs; [
    vscode-marketplace.jnoortheen.nix-ide
    vscode-marketplace.rust-lang.rust-analyzer
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
  };
}
