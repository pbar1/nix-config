{ pkgs, ... }:

let
  # Disable Nix fzf Fish shell integration; we use a plugin instead
  fzf = pkgs.fzf.overrideAttrs (oldAttrs: { preInstall = null; });
in
{
  home.packages = with pkgs; [
    # Editor
    (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" ]; })
    chafa

    # Version control & project tools
    direnv
    gnupg
    go-task
    tokei

    # Command line utils
    _1password
    coreutils
    exa
    fd
    fzf
    gnused
    hyperfine
    jq
    less
    procs
    ripgrep
    sd
    unixtools.watch
    xz
    yubikey-manager

    # Networking
    eternal-terminal

    # Rust
    rustup

    # Nix
    cachix
    nixpkgs-fmt
    rnix-lsp
    statix

    # Bash
    nodePackages.bash-language-server
    shellcheck
    shfmt

    # Lua
    selene
    stylua
    sumneko-lua-language-server
  ];
}
