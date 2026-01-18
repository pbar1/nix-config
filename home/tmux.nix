{
  programs.tmux.enable = true;
  programs.tmux.disableConfirmationPrompt = true;
  programs.tmux.mouse = true;
  programs.tmux.terminal = "tmux-256color";
  programs.tmux.baseIndex = 1;
  programs.tmux.escapeTime = 0;
  programs.tmux.historyLimit = 50000;
  programs.tmux.focusEvents = true;

  # TODO: Have <prefix>U launch tmux, and maybe copy config file
  # TODO: Keybind to temp disable prefix
  programs.tmux.extraConfig = ''
    set -g renumber-windows on

    # Allows nested tmux sessions to propagate clipboard
    set -s set-clipboard on

    # Keybindings

    # Additional prefix
    set-option -g prefix2 M-Space
    bind-key M-Space send-prefix -2

    bind r source-file ~/.config/tmux/tmux.conf \; \
      display "Reloaded tmux config"

    bind-key / copy-mode \; \
      command-prompt -i -p "search-up" "send-keys -X search-backward-incremental \"%%%\""

    # Paste local config into remote sessions
    bind-key U load-buffer ~/.config/tmux/tmux.conf \; \
      send-keys "cat << 'EOF' | tmux source-file /dev/stdin" Enter \; \
      paste-buffer -p \; \
      send-keys Enter "EOF" Enter

    # Status line

    set -g status-position top
    set -g status-justify left
    set -g status-style "bg=default,fg=default"

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
