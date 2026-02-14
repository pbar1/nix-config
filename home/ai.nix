{
  home.sessionVariables = {
    OPENCODE_ENABLE_EXA = "true";
    OPENCODE_EXPERIMENTAL_LSP_TOOL = "true";
  };

  programs.opencode.enable = true;
  programs.opencode.enableMcpIntegration = true;
  programs.opencode.settings = {
    theme = "system"; # Matches terminal theme
  };

  programs.claude-code.enable = true;

  programs.codex.enable = true;
}
