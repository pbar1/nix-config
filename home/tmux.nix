{
  programs.tmux.enable = true;
  programs.tmux.disableConfirmationPrompt = true;
  programs.tmux.mouse = true;
  programs.tmux.terminal = "tmux-256color";
  programs.tmux.prefix = "M-space";
  programs.tmux.baseIndex = 1;
  programs.tmux.escapeTime = 0;
  programs.tmux.historyLimit = 50000;
  programs.tmux.focusEvents = true;

  programs.tmux.extraConfig = ''
    set -g renumber-windows on

    # Keybindings

    bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux config"

    # New window (tab)
    unbind c
    bind t new-window -c "#{pane_current_path}"

    # Vim-like split panes
    unbind '"'
    unbind %
    bind s split-window -v -c "#{pane_current_path}"
    bind v split-window -h -c "#{pane_current_path}"

    # Status line

    set -g status-position top
    set -g status-justify left
    set -g status-style "bg=default,fg=default" # Transparent/Terminal background

    # Left side
    set -g status-left-length 20
    # If prefix is active, session indicator turns yellow
    set -g status-left "#{?client_prefix,#[fg=black bg=yellow],#[fg=black bg=blue]} #S "

    # Window list (tabs)
    set -g window-status-format "#[fg=brightwhite,bg=brightblack] #I:#W "
    set -g window-status-current-format "#[fg=black,bg=white,bold] #I:#W "
    set -g window-status-separator ""

    # Right side
    set -g status-right-length 50
    set -g status-right "#[fg=brightwhite,bg=brightblack] %Y-%m-%d #[fg=black,bg=white] %H:%M "
  '';
}
