{ inputs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.pierce = {
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "22.05";

    imports = [
      inputs.nixvim.homeModules.nixvim
      ../home/env.nix
      ../home/fish.nix
      ../home/fzf.nix
      ../home/ghostty.nix
      ../home/git.nix
      ../home/gpg.nix
      ../home/nvim.nix
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

    # Theme set with environment variable BAT_THEME since Delta also uses it
    programs.bat.enable = true;
    programs.bat.config.style = "plain";
  };
}
