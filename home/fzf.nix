{ pkgs, ... }:
let
  historyAge = pkgs.writeText "fzf-history-age.awk" ''
    BEGIN { FS = OFS = "\t"; RS = ORS = "\0"; now = systime() }
    {
      age = now - $2
      label = age < 60 ? int(age) "s" : age < 3600 ? int(age / 60) "m" :
        age < 86400 ? int(age / 3600) "h" : age < 2592000 ? int(age / 86400) "d" :
        age < 31536000 ? int(age / 2592000) "mo" : int(age / 31536000) "y"
      sub(/^[0-9]+/, label, $2)
      print
    }
  '';
in
{
  programs.fzf = {
    enable = true;
    package = pkgs.fzf.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace shell/key-bindings.fish \
          --replace-fail 'set -lx -- FZF_DEFAULT_OPTS ' \
            'set -a FZF_DEFAULT_COMMAND "| ${pkgs.gawk}/bin/awk -f ${historyAge}"; set -lx -- FZF_DEFAULT_OPTS '
      '';
    });
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
