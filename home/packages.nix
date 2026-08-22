{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editor
    nvim-pbar

    # Version control & project tools
    go-task
    tokei

    # GNU userland
    ncurses

    # Command line utils
    _1password-cli
    coreutils
    eza
    fd
    file
    gnused
    gawk
    jq
    dyff
    procs
    pstree
    ripgrep
    sd
    unixtools.watch
    xz

    # Networking
    dig
    nmap
    eternal-terminal
    openssh

    # Database
    duckdb
    sqlite

    # Containers & Kubernetes
    krew
    kubectl
    kubectx
    kubernetes-helm
    stern

    # Nix
    nixd
    nixfmt

    # Bash
    bash-language-server
    shellcheck
    shfmt

    # Rust
    rustup

    # Go
    go
    gopls

    # Python
    (python3.withPackages (
      p: with p; [
        python-dateutil
        pyyaml
        requests
      ]
    ))
    black
    isort
    uv

    # Lua
    stylua

    # JavaScript
    nodejs
    bun
    prettier

    # Dotnet and C#
    (
      with dotnetCorePackages;
      combinePackages [
        sdk_10_0
      ]
    )
  ];
}
