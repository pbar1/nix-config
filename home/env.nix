{ config, pkgs, ... }:

let
  configHome = config.xdg.configHome;
  dataHome = config.xdg.dataHome;
  cacheHome = config.xdg.cacheHome;
  binHome = "${config.home.homeDirectory}/.local/bin";
in
{
  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "sh -c 'col -bx | bat --plain --language=man'";
    /* TERMINFO = "${dataHome}/terminfo"; */
    /* TERMINFO_DIRS = "${dataHome}/terminfo:/usr/share/terminfo"; */
    SSH_AGENT_PID = "";
    LESS = "--mouse --use-color --RAW-CONTROL-CHARS --quit-if-one-screen";
    LESSKEY = "${configHome}/less/lesskey";
    LESSHISTFILE = "${cacheHome}/less/history";
    XZ_DEFAULTS = "--verbose --keep --threads=0";
    ZSTD_NBTHREADS = "0";
    FZF_DEFAULT_COMMAND = "fd --type=file --exclude=.git --hidden --follow";
    # FZF_DEFAULT_OPTS = "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD";
    KDEHOME = "${configHome}/kde";
    GTK_RC_FILES = "${configHome}/gtk-1.0/gtkrc";
    GTK2_RC_FILES = "${configHome}/gtk-2.0/gtkrc";
    GOPATH = "${dataHome}/go";
    RUSTUP_HOME = "${dataHome}/rustup";
    CARGO_HOME = "${dataHome}/cargo";
    DOTNET_ROOT = "${pkgs.dotnet-sdk.outPath}";
    NUGET_PACKAGES = "${cacheHome}/NuGetPackages";
    PYLINTHOME = "${cacheHome}/pylint";
    GEM_HOME = "${dataHome}/gem";
    GEM_SPEC_CACHE = "${cacheHome}/gem";
    NODE_REPL_HISTORY = "${dataHome}/node_repl_history";
    NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
    NVM_DIR = "${dataHome}/nvm";
    DENO_INSTALL_ROOT = "${dataHome}/deno";
    PSQLRC = "${configHome}/pg/psqlrc";
    PSQL_HISTORY = "${cacheHome}/pg/psql_history";
    PGPASSFILE = "${configHome}/pg/pgpass";
    PGSERVICEFILE = "${configHome}/pg/pg_service.conf";
    DOCKER_CONFIG = "${configHome}/docker";
    MACHINE_STORAGE_PATH = "${dataHome}/docker-machine";
    K9SCONFIG = "${configHome}/k9s";
    DCOS_DIR = "${configHome}/dcos";
    TF_CLI_CONFIG_FILE = "${configHome}/terraform/terraformrc";
    VAULT_CONFIG_PATH = "${configHome}/vault/config";
    VAGRANT_HOME = "${dataHome}/vagrant";
    VAGRANT_ALIAS_FILE = "${dataHome}/vagrant/aliases";
    AWS_SHARED_CREDENTIALS_FILE = "${configHome}/aws/credentials";
    AWS_CONFIG_FILE = "${configHome}/aws/config";
    AWS_VAULT_KEYCHAIN_NAME = "login";
    GOOGLE_APPLICATION_CREDENTIALS = "${configHome}/gcp/credentials.json";
    CODEPATH = "${config.home.homeDirectory}/code";

    # TODO: Await fix: https://github.com/NixOS/nixpkgs/issues/148946
    # VSCODE_LLDB_PATH = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";
    VSCODE_LLDB_PATH = "${config.home.homeDirectory}/.vscode/extensions/vadimcn.vscode-lldb-1.7.0";
  };

  xdg.configFile."npm/npmrc".text = ''
    prefix=${dataHome}/npm
    cache=${cacheHome}/npm
    init-module=${configHome}/npm/config/npm-init.js
  '';

  xdg.configFile."vault/config".text = ''
    token_helper = "${binHome}/vault-token-helper"
  '';
}
