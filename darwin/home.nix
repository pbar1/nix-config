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
      RAW-CONTROL-CHARS = true;
    };

    programs.bat.enable = true;
    programs.bat.config = {
      style = "plain";
      theme = "base16";
    };

    programs.dircolors.enable = true;

    programs.zoxide.enable = true;
  };
}
