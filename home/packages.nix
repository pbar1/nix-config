{ pkgs, ... }:

# https://nixos.org/guides/nix-pills/override-design-pattern.html
# Used `nix repl '<nixpkgs>'` to play around with this
let
  # Disable fzf builtin Fish shell integration; we use a plugin instead
  fzf = pkgs.fzf.overrideAttrs (oldAttrs: { preInstall = null; });
in
{
  home.packages = with pkgs; [
    # Editor
    (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" ]; })
    chafa

    # Version control & project tools
    gnupg
    gh # FIXME use hm
    tokei
    go-task
    direnv
    mdbook
    ninja
    lazygit

    # Command line utils
    coreutils
    fzf
    ripgrep
    fd
    sd
    exa
    hyperfine
    unixtools.watch
    less
    gnused
    jq
    _1password
    xz
    procs
    openssl
    yubikey-manager

    # Networking
    netcat
    socat
    eternal-terminal
    hey
    jwt-cli

    # Containers & Kubernetes
    dive
    kubectl
    krew
    kubernetes-helm
    stern
    kind

    # Nix
    rnix-lsp
    nixpkgs-fmt
    statix
    cachix

    # Bash
    shellcheck
    shfmt
    nodePackages.bash-language-server

    # C/C++
    cmake
    vscode-extensions.vadimcn.vscode-lldb

    # Rust
    (fenix.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer

    # Go
    go

    # Python
    (python39.withPackages (ps: with ps; [
      pyyaml
    ]))
    pipenv
    black
    python3Packages.isort
    nodePackages.pyright
    #python3Packages.debugpy

    # JavaScript
    nodejs
    nodePackages.prettier
    yarn

    # Lua
    stylua
    sumneko-lua-language-server
  ];
}
