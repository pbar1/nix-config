{ ... }:

{
  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = false;
    defaultCommand = "fd --type=file --exclude=.git --hidden --follow";
    defaultOptions = [
      "--color=16,fg+:-1,hl:4,hl+:4"
      "--color=prompt:3,spinner:6,pointer:6,header:4"
      "--color=marker:6,border:8,label:7"
    ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = false; # Otherwise `(eval):27: command not found: atuin` on shell launch
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      sync_address = "https://atuin.xnauts.net";
      network_timeout = "600";
    };
  };
}
