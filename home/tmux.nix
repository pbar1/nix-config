{
  programs.tmux.enable = true;
  programs.tmux.disableConfirmationPrompt = true;
  programs.tmux.mouse = true;
  programs.tmux.terminal = "tmux-256color";
  programs.tmux.prefix = "M-space";
  programs.tmux.baseIndex = 1;
  programs.tmux.escapeTime = 0;

  programs.tmux.extraConfig = ''
    set -g renumber-windows on

    # Vim-like pane splits
    unbind '"'
    unbind %
    bind s split-window -v -c "#{pane_current_path}"
    bind v split-window -h -c "#{pane_current_path}"
  '';
}
