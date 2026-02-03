{ inputs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.pierce = {
    imports = [
      ../home/env.nix
      ../home/fish.nix
      ../home/fzf.nix
      ../home/ghostty.nix
      ../home/git.nix
      ../home/gpg.nix
      ../home/packages.nix
      ../home/ssh.nix
      ../home/opencode.nix
      ../home/starship.nix
      ../home/tmux.nix
      ../home/vscode.nix
      ../home/wezterm
      ../home/zsh.nix
    ];

    # Don't show Home Manager news on switch
    news.display = "silent";

    programs.home-manager.enable = true;

    # Fish shell enables this for `man` completion to work, but it is very slow
    # https://github.com/NixOS/nixpkgs/issues/100288
    programs.man.generateCaches = false;

    programs.zoxide.enable = true;

    programs.bat.enable = true;
    programs.bat.config = {
      style = "plain";
      theme = "ansi";
    };

    programs.dircolors.enable = true;
  };
}
