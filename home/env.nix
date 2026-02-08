{ config, pkgs, ... }:

let
  home = config.home.homeDirectory;
  configHome = config.xdg.configHome;
  dataHome = config.xdg.dataHome;
  cacheHome = config.xdg.cacheHome;
in
{
  xdg.enable = true;

  home.sessionPath = [
    "${home}/code/bin"
    "${home}/.local/bin"
    "${home}/.krew/bin"
    "${dataHome}/cargo/bin"
    "${dataHome}/go/bin"
    "${dataHome}/npm/bin"
    "/opt/homebrew/bin"
  ];

  home.sessionVariables = rec {
    EDITOR = "nvim";
    VISUAL = EDITOR;
    # MANPAGER = "sh -c 'col -bx | bat --plain --language=man'";
    SSH_AGENT_PID = "";
    LESS = "--quit-if-one-screen --RAW-CONTROL-CHARS"; # --mouse breaks iTerm mouse select
    LESSKEY = "${configHome}/less/lesskey";
    LESSHISTFILE = "${cacheHome}/less/history";
    XZ_DEFAULTS = "--verbose --keep --threads=0";
    ZSTD_NBTHREADS = "0";
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
    PSQLRC = "${configHome}/pg/psqlrc";
    PSQL_HISTORY = "${cacheHome}/pg/psql_history";
    PGPASSFILE = "${configHome}/pg/pgpass";
    PGSERVICEFILE = "${configHome}/pg/pg_service.conf";
    RIPGREP_CONFIG_PATH = "${configHome}/ripgrep/config";
    TF_CLI_CONFIG_FILE = "${configHome}/terraform/terraformrc";
    VAULT_CONFIG_PATH = "${configHome}/vault/config";
    VAGRANT_HOME = "${dataHome}/vagrant";
    VAGRANT_ALIAS_FILE = "${dataHome}/vagrant/aliases";
    AWS_SHARED_CREDENTIALS_FILE = "${configHome}/aws/credentials";
    AWS_CONFIG_FILE = "${configHome}/aws/config";
    AWS_VAULT_KEYCHAIN_NAME = "login";
    GOOGLE_APPLICATION_CREDENTIALS = "${configHome}/gcp/credentials.json";
    CODEPATH = "${config.home.homeDirectory}/code";
    BAT_THEME = "base16";
  };

  xdg.configFile."npm/npmrc".text = ''
    prefix=${dataHome}/npm
    cache=${cacheHome}/npm
    init-module=${configHome}/npm/config/npm-init.js
  '';

  programs.direnv.enable = true;
}
