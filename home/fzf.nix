{ pkgs, ... }:
let
  historyAge = pkgs.writeText "fzf-history-age.awk" ''
    BEGIN { FS = OFS = "\t"; RS = ORS = "\0"; now = systime() }
    {
      age = now - $2
      # Match Git's show_date_relative() rounding and thresholds.
      minutes = int((age + 30) / 60)
      hours = int((minutes + 30) / 60)
      days = int((hours + 12) / 24)
      months = int((days * 24 + 365) / 730)
      label = age < 0 ? "in the future" : age < 90 ? age "s" :
        minutes < 90 ? minutes "m" : hours < 36 ? hours "h" :
        days < 14 ? days "d" : days < 70 ? int((days + 3) / 7) "w" :
        days < 365 ? int((days + 15) / 30) "mo" :
        days < 1825 ? int(months / 12) "y" (months % 12 ? months % 12 "mo" : "") :
        int((days + 183) / 365) "y"
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
