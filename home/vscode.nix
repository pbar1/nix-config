{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  jsonFormat = pkgs.formats.json { };
  configDir = if isDarwin then "Library/Application Support" else config.xdg.configHome;
  os = if isDarwin then "osx" else "linux";
  editors = [ "VSCodium" ];

  # Literal `\u` is impossible without this: https://github.com/NixOS/nix/issues/10082
  tmuxPrefix = builtins.fromJSON ''"\u0002"''; # C-b
  termBind = vscodeKey: tmuxKey: {
    key = vscodeKey;
    command = "workbench.action.terminal.sendSequence";
    args.text = tmuxKey;
    when = "terminalFocus";
  };

  keybindings = [
    {
      key = "shift+cmd+enter";
      command = "workbench.action.toggleMaximizedPanel";
    }
    {
      command = "workbench.action.splitEditor";
      key = "cmd+d";
    }
    {
      command = "-workbench.action.splitEditor";
      key = "cmd+\\";
    }
    {
      command = "workbench.action.splitEditorOrthogonal";
      key = "shift+cmd+d";
    }
    {
      command = "-workbench.action.splitEditorOrthogonal";
      key = "cmd+k cmd+\\";
    }
    {
      command = "workbench.action.zoomIn";
      key = "cmd+=";
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

  settings = {
    "[dockercompose]" = {
      "editor.autoIndent" = "advanced";
      "editor.defaultFormatter" = "redhat.vscode-yaml";
      "editor.insertSpaces" = true;
      "editor.tabSize" = 2;
    };
    "[dockerfile]" = {
      "editor.formatOnSave" = false;
    };
    "[github-actions-workflow]" = {
      "editor.defaultFormatter" = "redhat.vscode-yaml";
    };
    "[go]" = {
      "editor.insertSpaces" = false;
    };
    "[html]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[javascript]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[javascriptreact]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[json]" = {
      "editor.defaultFormatter" = "vscode.json-language-features";
    };
    "[jsonc]" = {
      "editor.defaultFormatter" = "vscode.json-language-features";
    };
    "[markdown]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[mdx]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
    };
    "[plaintext]" = {
      "editor.formatOnSave" = false;
    };
    "[python]" = {
      "editor.codeActionsOnSave" = {
        "source.organizeImports" = "explicit";
      };
      "editor.defaultFormatter" = "ms-python.black-formatter";
    };
    "[rust]" = {
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
    };
    "[typescript]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[typescriptreact]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[yaml]" = {
      "editor.defaultFormatter" = "kennylong.kubernetes-yaml-formatter";
    };
    "cSpell.userWords" = [
      "pbcloud"
      "pulumi"
      "traefik"
    ];
    "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
    "editor.fontFamily" = "Iosevka Nerd Font";
    "editor.fontSize" = 14;
    "editor.formatOnSave" = true;
    "editor.minimap.autohide" = "mouseover";
    "editor.minimap.enabled" = false;
    "editor.renderWhitespace" = "boundary";
    "editor.semanticHighlighting.enabled" = true;
    "editor.wordWrap" = "off";
    "errorLens.excludeByMessage" = [
      ": Unknown word."
    ];
    "evenBetterToml.formatter.arrayAutoExpand" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "extensions.autoUpdate" = false;
    "extensions.ignoreRecommendations" = true;
    "files.associations" = {
      "LICENSE*" = "plaintext";
    };
    "files.eol" = "\n";
    "files.exclude" = {
      "**/.sl" = true;
    };
    "git.openRepositoryInParentFolders" = "never";
    "go.useLanguageServer" = true;
    "gruvboxMaterial.darkContrast" = "soft";
    "gruvboxMaterial.darkPalette" = "material";
    "gruvboxMaterial.darkWorkbench" = "high-contrast";
    "gruvboxMaterial.lightContrast" = "soft";
    "gruvboxMaterial.lightPalette" = "material";
    "gruvboxMaterial.lightWorkbench" = "high-contrast";
    "isort.args" = [
      "--profile"
      "black"
    ];
    "keyboard.dispatch" = "keyCode";
    "lldb.suppressUpdateNotifications" = true;
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.serverSettings".nixd.formatting.command = [ "nixfmt" ];
    "python.analysis.typeCheckingMode" = "strict";
    "redhat.telemetry.enabled" = false;
    "rust-analyzer.check.command" = "clippy";
    "rust-analyzer.restartServerOnConfigChange" = true;
    "rust-analyzer.rustfmt.extraArgs" = [ "+nightly" ];
    "security.workspace.trust.untrustedFiles" = "open";
    "settingsSync.ignoredSettings" = [
      "workbench.colorTheme"
    ];
    "telemetry.telemetryLevel" = "off";
    "terminal.integrated.copyOnSelection" = true;
    "terminal.integrated.defaultProfile.${os}" = "tmux";
    "terminal.integrated.fontSize" = 14;
    "terminal.integrated.initialHint" = false;
    "terminal.integrated.macOptionIsMeta" = true;
    "terminal.integrated.profiles.${os}" = {
      tmux = {
        path = "tmux";
        icon = "terminal-tmux";
        args = [
          "new-session"
          "-A"
          "-s"
          "\${workspaceFolderBasename}"
        ];
      };
    };
    "terminal.integrated.rightClickBehavior" = "copyPaste";
    "update.mode" = "none";
    "vsicons.dontShowNewVersionMessage" = true;
    "window.autoDetectColorScheme" = true;
    "window.nativeTabs" = true;
    "workbench.editor.empty.hint" = "hidden";
    "workbench.editorAssociations" = {
      "*.bin" = "hexEditor.hexedit";
    };
    "workbench.iconTheme" = "vscode-icons";
    "workbench.preferredDarkColorTheme" = "Gruvbox Material Dark";
    "workbench.preferredLightColorTheme" = "Gruvbox Material Light";
    "workbench.startupEditor" = "none";
    "yaml.format.enable" = true;
  };

in
{
  home.file = lib.listToAttrs (
    lib.concatMap (editor: [
      {
        name = "${configDir}/${editor}/User/settings.json";
        value.source = jsonFormat.generate "vscode-settings" settings;
      }
      {
        name = "${configDir}/${editor}/User/keybindings.json";
        value.source = jsonFormat.generate "vscode-keybindings" keybindings;
      }
    ]) editors
  );
}
