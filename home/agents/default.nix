{ config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

  repo = "${homeDirectory}/code/nix-config";
  agentsFile = mkOutOfStoreSymlink "${repo}/home/agents/README.md";
in

{
  home.sessionVariables = {
    OPENCODE_ENABLE_EXA = "true";
    OPENCODE_EXPERIMENTAL_LSP_TOOL = "true";
  };

  xdg.configFile."agents/AGENTS.md".source = agentsFile;
  xdg.configFile."opencode/AGENTS.md".source = agentsFile;
  home.file.".claude/CLAUDE.md".source = agentsFile;
  home.file.".codex/AGENTS.md".source = agentsFile;

  programs.opencode.enable = true;
  programs.opencode.enableMcpIntegration = true;
  programs.opencode.tui.theme = "system";

  programs.claude-code.enable = true;

  programs.codex.enable = true;
}
