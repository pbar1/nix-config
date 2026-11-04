{ ... }:

{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type=file --exclude=.git --hidden --follow";
    defaultOptions = [
      "--color=16,fg+:-1,hl:4,hl+:4"
      "--color=prompt:3,spinner:6,pointer:6,header:4"
      "--color=marker:6,border:8,label:7"
    ];
  };
}
