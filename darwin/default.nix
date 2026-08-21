{
  inputs,
  pkgs,
  config,
  ...
}:

let
  user = config.system.primaryUser;
  kanataConfig = ../keyboard/kanata.kbd;
in

{
  imports = [
    ./packages.nix
    ./home.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  nix.registry.nixpkgs.flake = inputs.nixpkgs; # `nix` uses nixpkgs from flake

  nix.enable = true;
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.bash-prompt-prefix = "(nix:$name)\\040";
  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://devenv.cachix.org"
    "https://pbar1.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    "pbar1.cachix.org-1:DsBqAi4CnR7TaABRn59sUBBK+lofYhQaV8lK8nl2gow="
  ];
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];
  nix.settings.download-buffer-size = 500000000;
  nix.distributedBuilds = true;
  nix.linux-builder.enable = true;
  nix.linux-builder.config.virtualisation.qemu.options = [ "-machine gic-version=3" ];

  # Handy list of macOS `defaults` options
  # https://github.com/LnL7/nix-darwin/blob/master/tests/system-defaults-write.nix

  # Dock
  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-time-modifier = 0.0;
  system.defaults.dock.autohide-delay = 0.0;
  system.defaults.dock.orientation = "bottom";

  # Falls back to default if directory doesn't exist
  system.defaults.screencapture.location = "~/Pictures/Screenshots";

  # Keyboard settings
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3; # Enable full keyboard in modal dialogs
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10; # 150 ms
  system.defaults.NSGlobalDomain.KeyRepeat = 1; # 15 ms
  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true; # ctrl+cmd+drag any part of window

  # Enable shell integrations so that Nix paths are setup properly. Does not
  # conflict with Home Manager shell integrations
  programs.bash.enable = true;
  programs.fish.enable = true;
  programs.zsh.enable = true;

  # TouchID for sudo, also works within tmux
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  # User configuration
  users.users."${user}" = {
    home = "/Users/${user}";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvmdvrrgYY3Q+Wp/SyQm2a2OWL82S2Z+e+FoJ/vmS/D personal@1password"
    ];
  };

  launchd.daemons = {
    # Keyboard remapper. Must have Karabiner driver running, but NOT Karabiner
    # itself (ie, it should not be in the menu bar).
    # https://github.com/jtroo/kanata/discussions/1537
    kanata = {
      command = "/opt/homebrew/bin/kanata --cfg ${kanataConfig} --release-grab-on-lock";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Interactive";
        StandardOutPath = "/Library/Logs/Kanata/kanata.out.log";
        StandardErrorPath = "/Library/Logs/Kanata/kanata.err.log";
      };
    };
  };

  # FIXME: Touch ~/.hushlogin to disable last login time
}
