# https://github.com/ianthehenry/dotfiles/blob/master/.tmux.conf
# https://ianthehenry.com/posts/tmux-copy-last-command/
# https://willhbr.net/2024/03/06/tmux-conf-with-commentary/
# TODO: Have <prefix>U launch tmux, and maybe copy config file
# TODO: Keybind to temp disable prefix

{
  programs.tmux.enable = true;
  programs.tmux.disableConfirmationPrompt = true;
  programs.tmux.mouse = true;
  programs.tmux.terminal = "tmux-256color";
  programs.tmux.baseIndex = 1;
  programs.tmux.escapeTime = 0;
  programs.tmux.historyLimit = 50000;
  programs.tmux.focusEvents = true;

  programs.tmux.extraConfig = ''
    set -g renumber-windows on

    # Allow nested tmux sessions to propagate clipboard
    set -s set-clipboard on

    # Keybindings

    # Additional prefix
    set -g prefix2 M-Space
    bind M-Space send-prefix -2

    bind -N "Reload tmux config" r {
      source-file ~/.config/tmux/tmux.conf
      display "Reloaded tmux config"
    }

    # Splits open in same directory
    bind -N "Split window vertically" '"' split-window -v -c "#{pane_current_path}"
    bind -N "Split window horizontally" %  split-window -h -c "#{pane_current_path}"

    bind -N "Toggle pane synchronization" e {
      set-window-option synchronize-panes
      display-message "Synchronize panes: #{?pane_synchronized,ON,OFF}"
    }

    bind / {
      copy-mode
      command-prompt -i -p "search-up" "send-keys -X search-backward-incremental \"%%%\""
    }

    bind -N "Paste local config into remote tmux session" U {
      load-buffer ~/.config/tmux/tmux.conf
      send-keys "cat << 'EOF' | tmux source-file /dev/stdin" Enter
      paste-buffer -p
      send-keys Enter "EOF" Enter
    }

    bind -N "Copy last command and output" Y {
      copy-mode
      send-keys -X begin-selection
      send-keys -X previous-prompt
      send-keys -X copy-pipe-and-cancel
    }

    # Status line

    set -g status-position top
    set -g status-justify left
    set -g status-style "bg=default,fg=default"

    # Left side
    set -g status-left-length 20
    set -g status-left "#{?client_prefix,#[fg=black bg=yellow],#{?pane_synchronized,#[fg=black bg=red],#[fg=black bg=blue]}} #S "

    # Window list (tabs)
    set -g window-status-format "#[fg=brightwhite,bg=brightblack] #I:#W "
    set -g window-status-current-format "#[fg=black,bg=white,bold] #I:#W "
    set -g window-status-separator ""

    # Right side
    set -g status-right-length 50
    set -g status-right "#[fg=black,bg=white] #H "
  '';
}
