{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;
  inherit (config.xdg) configHome;

  repo = "${homeDirectory}/code/nix-config";
  agentsFile =
    if pkgs.stdenv.hostPlatform.isDarwin then
      mkOutOfStoreSymlink "${repo}/home/agents/README.md"
    else
      ./README.md;
in

{
  # Shared
  xdg.configFile."agents/AGENTS.md".source = agentsFile;
  programs.mcp.enable = true;
  programs.mcp.servers.grep.url = "https://mcp.grep.app";
  programs.mcp.servers.home-assistant = {
    command = lib.getExe pkgs.mcp-proxy;
    args = [
      "--transport=streamablehttp"
      "--stateless"
      "https://ha.xnauts.net/api/mcp"
    ];
    env.API_ACCESS_TOKEN.file = "${configHome}/agents/home-assistant-mcp-token";
  };

  # OpenCode
  programs.opencode.enable = true;
  programs.opencode.enableMcpIntegration = true;
  programs.opencode.settings.permission = {
    edit."/nix/store/**" = "deny";
    external_directory."/nix/store/**" = "allow";
  };
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
