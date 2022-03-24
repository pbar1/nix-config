{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Pierce Bartine";
    userEmail = "piercebartine@gmail.com";
    signing.key = null; # GPG picks key based on email if not set
    signing.signByDefault = true;

    extraConfig = {
      push.default = "simple";
      push.followTags = true;
      pull.rebase = false;
      credential.helper = if pkgs.stdenv.isDarwin then "osxkeychain" else "gnome-keyring";
    };

    delta = {
      enable = true;
      options = {
        syntax-theme = "Solarized (light)";
        side-by-side = true;
      };
    };

    # FIXME: create this file
    includes = [{ path = "~/.config/git/config.sfdc"; condition = "gitdir:~/code/sfdc"; }];

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

    #attributes = [];
  };
}
