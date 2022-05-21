{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Pierce Bartine";
    signing.key = null; # GPG picks key based on email if not set
    signing.signByDefault = true;

    extraConfig = {
      push.default = "current";
      push.followTags = true;
      pull.rebase = false;
      credential.helper = if pkgs.stdenv.isDarwin then "osxkeychain" else "gnome-keyring";
    };

    delta = {
      enable = true;
      options = {
        syntax-theme = "gruvbox-light";
        side-by-side = true;
      };
    };

    aliases = {
      root = "rev-parse --show-toplevel";
      co = "checkout";
      unstage = "reset HEAD --";
      br = "branch";
      cm = "commit";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      zap = "remote prune origin";
      remotes = "remote --verbose";
      upstream-name = "!git remote | egrep -o '(upstream|origin)' | tail -1";
      head-branch = "!git remote show $(git upstream-name) | awk '/HEAD branch/ {print $NF}'";
      upstream-auto = "!git remote set-head origin --auto";
    };

    ignores = [
      "**/.idea/*"
      "**/.DS_Store"
    ];

    # attributes = [];

    # Load context-based config
    includes = [
      { path = "~/.config/git/config.personal"; condition = "gitdir:~/code/"; }
    ];
  };

  xdg.configFile."git/config.personal".text = ''
    [user]
      email = "piercebartine@gmail.com"

    [url "ssh://git@github.com/"]
      insteadOf = "https://github.com/"

    [url "ssh://git@gitlab.com/"]
      insteadOf = "https://gitlab.com/"
  '';
}
