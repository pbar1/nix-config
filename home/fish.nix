{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      fish_vi_key_bindings

      set -gx PATH "''$HOME/.local/bin:''$HOME/.krew/bin:${config.xdg.dataHome}/go/bin:${config.xdg.dataHome}/cargo/bin:${config.xdg.dataHome}/npm/bin:''$HOME/.nix-profile/bin:''$HOME/.brew/bin:''$PATH"

      set -gx GPG_TTY (tty)
      set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    '';

    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "6b592e4140168820f5df9dd28b0a93e409e0d0c3";
          sha256 = "sha256-dngAKzyD+lmqmxsCSOMViyCgA/+Ve35gLtPS+Lgs8Pc=";
        };
      }
      {
        name = "plugin-bang-bang";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-bang-bang";
          rev = "f969c618301163273d0a03d002614d9a81952c1e";
          sha256 = "sha256-A8ydBX4LORk+nutjHurqNNWFmW6LIiBPQcxS3x4nbeQ=";
        };
      }
      {
        name = "fish-kubectl-completions";
        src = pkgs.fetchFromGitHub {
          owner = "evanlucas";
          repo = "fish-kubectl-completions";
          rev = "ced676392575d618d8b80b3895cdc3159be3f628";
          sha256 = "sha256-OYiYTW+g71vD9NWOcX1i2/TaQfAg+c2dJZ5ohwWSDCc=";
        };
      }
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "2fd3d2157d5271ca3575b13daec975ca4c10577a";
          sha256 = "sha256-fl4/Pgtkojk5AE52wpGDnuLajQxHoVqyphE90IIPYFU=";
        };
      }
      {
        name = "pisces";
        src = pkgs.fetchFromGitHub {
          owner = "laughedelic";
          repo = "pisces";
          rev = "e45e0869855d089ba1e628b6248434b2dfa709c4";
          sha256 = "sha256-Oou2IeNNAqR00ZT3bss/DbhrJjGeMsn9dBBYhgdafBw=q";
        };
      }
      {
        name = "base16-fish-shell";
        src = pkgs.fetchFromGitHub {
          owner = "FabioAntunes";
          repo = "base16-fish-shell";
          rev = "d358af9a724715efd0d31b417ba56e622a239612";
          sha256 = "sha256-Bf6V/sF0NqUC2iCNXMZWM3ijpicnJhMpoKZSwOuiS3s=";
        };
      }
    ];
    # Dummy sha256: 01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b

    shellAbbrs = {
      c = "clear";
      e = "$EDITOR";
      g = "git";
      gs = "git status --short";
      gd = "git diff";
      ij = "idea";
      k = "kubectl";
      kapi = "kubectl api-resources";
      kge = "kubectl get events --watch";
      kgg = "kubectl get pods,replicasets,deployments,statefulsets,daemonsets,jobs,cronjobs";
      kgi = "kubectl get ingresses,services,endpoints,certificates,certificaterequests,certificatesigningrequests,challenges,orders";
      kgn = "kubectl get namespaces --show-labels";
      kgno = "kubectl get nodes --label-columns=beta.kubernetes.io/instance-type,failure-domain.beta.kubernetes.io/zone";
      kgp = "kubectl get pods";
      wkgp = "watch kubectl get pods";
      kn = "kubens";
      kubeconfig = "kubectl config view --minify --flatten";
      kx = "kubectx";
      lt = "exa --tree";
      nv = "nvim";
      rgf = "rg --fixed-strings";
      rgi = "rg --ignore-case";
      star = "starship";
      tf = "terraform";
      tfa = "terraform apply";
      tfp = "terraform plan";
      wo = "type --all --short";
      xi = "xargs -I {}";
    };

    shellAliases = {
      cat = "bat";
      copy = if pkgs.stdenv.isDarwin then "pbcopy" else "wl-copy --trim-newline";
      l = "exa --header --all --long --git";
      tree = "exa --tree";
      yktog = "ykman config usb --list | grep --quiet OTP && ykman config usb --force --disable=otp || ykman config usb --force --enable=otp";
    };

    functions = {
      light = ''
        base16-gruvbox-light-medium
        base16-fzf-gruvbox-light-medium
      '';

      dark = ''
        base16-gruvbox-dark-medium
        base16-fzf-gruvbox-dark-medium
      '';

      # https://github.com/fnune/base16-fzf/blob/master/fish/base16-gruvbox-light-medium.fish
      base16-fzf-gruvbox-light-medium = ''
        set -l color00 '#fbf1c7'
        set -l color01 '#ebdbb2'
        set -l color02 '#d5c4a1'
        set -l color03 '#bdae93'
        set -l color04 '#665c54'
        set -l color05 '#504945'
        set -l color06 '#3c3836'
        set -l color07 '#282828'
        set -l color08 '#9d0006'
        set -l color09 '#af3a03'
        set -l color0A '#b57614'
        set -l color0B '#79740e'
        set -l color0C '#427b58'
        set -l color0D '#076678'
        set -l color0E '#8f3f71'
        set -l color0F '#d65d0e'

        set -l FZF_NON_COLOR_OPTS

        for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
            if not string match -q -- "--color*" $arg
                set -a FZF_NON_COLOR_OPTS $arg
            end
        end

        set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
        " --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
        " --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
        " --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

      '';

      # https://github.com/fnune/base16-fzf/blob/master/fish/base16-gruvbox-dark-medium.fish
      base16-fzf-gruvbox-dark-medium = ''
        set -l color00 '#282828'
        set -l color01 '#3c3836'
        set -l color02 '#504945'
        set -l color03 '#665c54'
        set -l color04 '#bdae93'
        set -l color05 '#d5c4a1'
        set -l color06 '#ebdbb2'
        set -l color07 '#fbf1c7'
        set -l color08 '#fb4934'
        set -l color09 '#fe8019'
        set -l color0A '#fabd2f'
        set -l color0B '#b8bb26'
        set -l color0C '#8ec07c'
        set -l color0D '#83a598'
        set -l color0E '#d3869b'
        set -l color0F '#d65d0e'

        set -l FZF_NON_COLOR_OPTS

        for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
            if not string match -q -- "--color*" $arg
                set -a FZF_NON_COLOR_OPTS $arg
            end
        end

        set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
        " --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
        " --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
        " --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
      '';

      vault-login = ''
        set sel (cat "$XDG_CONFIG_HOME/vault/addrs" | grep -v '#' | fzf)
        set --global --export VAULT_ADDR (string split ';' -f 1 $sel)
        set --erase VAULT_TOKEN
        if not vault token lookup > /dev/null 2>&1
          set method (string split ';' -f 2 $sel)
          set params (string split ';' -f 3 $sel)
          vault login -no-print -method=$method $params
        end
        set --global --export VAULT_TOKEN (vault print token)
        echo "Switched to Vault: $VAULT_ADDR"
      '';

      vault-aws = ''
        set aws_role (vault list -format=json aws/roles | jq -r .[] | fzf)
        vault read -format=json aws/creds/$aws_role | jq -c . |  read --local vault_json
        set --erase AWS_VAULT AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN AWS_SESSION_TOKEN
        set --global --export AWS_ACCESS_KEY_ID (echo $vault_json | jq -r .data.access_key)
        set --global --export AWS_SECRET_ACCESS_KEY (echo $vault_json | jq -r .data.secret_key)
        set --global --export AWS_SESSION_TOKEN (echo $vault_json | jq -r .data.security_token)
        aws sts get-caller-identity
      '';
    };
  };
}
