{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;

    package = pkgs.vscode;

    extensions = (with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      christian-kohler.path-intellisense
      eamodio.gitlens
      editorconfig.editorconfig
      foxundermoon.shell-format
      golang.go
      james-yu.latex-workshop
      jdinhlife.gruvbox
      jnoortheen.nix-ide
      matklad.rust-analyzer
      ms-dotnettools.csharp
      ms-python.vscode-pylance
      redhat.vscode-yaml
      streetsidesoftware.code-spell-checker
      tamasfe.even-better-toml
      timonwong.shellcheck
      vadimcn.vscode-lldb
      yzhang.markdown-all-in-one
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-icons";
        publisher = "vscode-icons-team";
        version = "11.11.0";
        sha256 = "sha256-Zhc7JfXKaYZpVgiCi1Yj1ui2u9h94ocUjODIsDLwqWE=";
      }
      {
        name = "lua";
        publisher = "sumneko";
        version = "3.2.2";
        sha256 = "sha256-WEDDad3r6dSOPF2abKQWb5wN4g84UXzlKPaVvonq4Qc=";
      }
    ];

    userSettings = {
      "editor.bracketPairColorization.enabled" = true;
      "editor.fontFamily" = "Iosevka";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 16;
      "editor.formatOnSave" = true;
      "editor.renderWhitespace" = "boundary";
      "explorer.confirmDelete" = false;
      "nix.enableLanguageServer" = true;
      "rust-analyzer.inlayHints.parameterHints" = true;
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.copyOnSelection" = true;
      "terminal.integrated.fontSize" = 16;
      "terminal.integrated.rightClickBehavior" = "copyPaste";
      "vscode-neovim.neovimExecutablePaths.linux" = "${pkgs.neovim-nightly}/bin/nvim";
      "vsicons.dontShowNewVersionMessage" = true;
      "window.autoDetectColorScheme" = true;
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Gruvbox Light Medium";
      "workbench.iconTheme" = "vscode-icons";
      "workbench.preferredDarkColorTheme" = "Gruvbox Dark Medium";
      "workbench.preferredLightColorTheme" = "Gruvbox Light Medium";
      "workbench.startupEditor" = "none";

      # To respect <Caps> remaped to <Esc> on Linux
      # https://github.com/Microsoft/vscode/wiki/Keybinding-Issues#troubleshoot-linux-keybindings
      "keyboard.dispatch" = "keyCode";
    };

    # TODO: https://github.com/nix-community/home-manager/issues/2798
    mutableExtensionsDir = false;
  };
}
