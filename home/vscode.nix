{ pkgs, ... }:
let
  # FIXME: Does not escape properly in vscode json
  tmuxPrefix = "\\u0002";
  termBind = vscodeKey: tmuxKey: {
    key = vscodeKey;
    command = "workbench.action.terminal.sendSequence";
    args.text = tmuxKey;
    when = "terminalFocus";
  };
in
{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscodium;
  programs.vscode.mutableExtensionsDir = false;

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
    "nix.serverSettings".nixd.formatting.command = [ "nixfmt" ];
    "rust-analyzer.check.command" = "clippy";
    "rust-analyzer.restartServerOnConfigChange" = true;
    "rust-analyzer.rustfmt.extraArgs" = [ "+nightly" ];
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
    "window.autoDetectColorScheme" = true;
    # "workbench.preferredDarkColorTheme" = "Gruvbox Material Dark";
    # "workbench.preferredLightColorTheme" = "Gruvbox Material Light";
    "workbench.startupEditor" = "none";
  };

  programs.vscode.profiles.default.keybindings = [
    {
      key = "shift+cmd+enter";
      command = "workbench.action.toggleMaximizedPanel";
    }
    # macOS shortcuts for tmux
    (termBind "cmd+1" "${tmuxPrefix}1")
    (termBind "cmd+2" "${tmuxPrefix}2")
    (termBind "cmd+3" "${tmuxPrefix}3")
    (termBind "cmd+4" "${tmuxPrefix}4")
    (termBind "cmd+5" "${tmuxPrefix}5")
    (termBind "cmd+6" "${tmuxPrefix}6")
    (termBind "cmd+7" "${tmuxPrefix}7")
    (termBind "cmd+8" "${tmuxPrefix}8")
    (termBind "cmd+9" "${tmuxPrefix}9")
    (termBind "cmd+t" "${tmuxPrefix}c")
    (termBind "cmd+w" "${tmuxPrefix}x")
    (termBind "cmd+d" "${tmuxPrefix}%")
    (termBind "shift+cmd+d" ''${tmuxPrefix}"'')
    (termBind "cmd+f" "${tmuxPrefix}/")
  ];
}
