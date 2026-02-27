{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editor
    nvim-pbar

    # Version control & project tools
    go-task
    tokei
    pre-commit
    git-branchless

    # Other
    starship-claude

    # Command line utils
    _1password-cli
    coreutils
    eza
    fd
    file
    gnused
    gawk
    hyperfine
    jq
    dyff
    procs
    pstree
    ripgrep
    ast-grep
    sd
    unixtools.watch
    xz
    ffmpeg
    tlrc
    glow

    # Networking
    dig
    nmap
    socat
    eternal-terminal

    # Database
    duckdb
    sqlite

    # Cloud
    terraform
    google-cloud-sdk

    # Containers & Kubernetes
    krew
    kubectl
    kubectx
    kubernetes-helm
    stern
    k3d
    dive

    # Nix
    cachix
    nix-tree
    nixd
    nixfmt

    # Bash
    nodePackages.bash-language-server
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

    # Lua
    stylua

    # JavaScript
    nodejs
    yarn-berry
    deno
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
