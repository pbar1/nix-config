{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.pierce = {
    imports = [
      ../home/ai.nix
      ../home/env.nix
      ../home/fish.nix
      ../home/fzf.nix
      ../home/ghostty.nix
      ../home/git.nix
      ../home/gpg.nix
      ../home/packages.nix
      ../home/ssh.nix
      ../home/starship.nix
      ../home/tmux
      ../home/vscode.nix
      ../home/wezterm
      ../home/zsh.nix
    ];

    # Don't show Home Manager news on switch
    news.display = "silent";

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
      "*.{nix}" = {
        indent_size = 2;
      };
    };
  };
}
