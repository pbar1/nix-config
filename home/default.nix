{ ... }:

{
  imports = [
    ./agents
    ./env.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./packages.nix
    ./ssh.nix
    ./starship.nix
    ./tmux
    ./zsh.nix
  ];

  # Don't show Home Manager news on switch
  news.display = "silent";

  # Using `follows` in Flake inputs so versions are not mismatched
  home.enableNixpkgsReleaseCheck = false;

  programs.home-manager.enable = true;

  programs.less.enable = true;
  programs.less.options = {
    LONG-PROMPT = true;
    RAW-CONTROL-CHARS = true;
    ignore-case = true;
    mouse = true;
    quiet = true;
    quit-if-one-screen = true;
  };

  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
    theme = "base16";
  };

  programs.dircolors.enable = true;

  programs.zoxide.enable = true;

  editorconfig.enable = true;
  editorconfig.settings = {
    # Sections merge, later wins
    "*" = {
      charset = "utf-8";
      end_of_line = "lf";
      indent_size = 4;
      indent_style = "space";
      insert_final_newline = true;
      trim_trailing_whitespace = true;
    };
    "*.{nix,yml,yaml}" = {
      indent_size = 2;
    };
  };
}
