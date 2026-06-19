{ config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

  repo = "${homeDirectory}/code/nix-config";
  agentsFile = mkOutOfStoreSymlink "${repo}/home/agents/README.md";
in

{
  # Shared
  xdg.configFile."agents/AGENTS.md".source = agentsFile;
  programs.mcp.enable = true;
  programs.mcp.servers.grep.url = "https://mcp.grep.app";

  # OpenCode
  programs.opencode.enable = true;
  programs.opencode.enableMcpIntegration = true;
  programs.opencode.tui.theme = "system";
  home.sessionVariables.OPENCODE_ENABLE_EXA = "true";
  home.sessionVariables.OPENCODE_EXPERIMENTAL_LSP_TOOL = "true";
  xdg.configFile."opencode/AGENTS.md".source = agentsFile;

  # Claude
  programs.claude-code.enable = true;
  home.file.".claude/CLAUDE.md".source = agentsFile;

  # Codex
  programs.codex.enable = true;
  home.file.".codex/AGENTS.md".source = agentsFile;
}
