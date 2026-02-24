{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;

  userName = "Pierce Bartine";
  userEmail = "piercebartine@gmail.com";
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDim41ofReCgbmijkayBsFg5TlO9qqV8b6Y8Xcwnr49m github@1password";

  credentialHelper = if isDarwin then "osxkeychain" else "libsecret";
  sshSignProgram =
    if isDarwin then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign" else null;
in
{
  programs.difftastic.enable = true;

  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;
  programs.delta.options = {
    hyperlinks = true;
    hyperlinks-file-link-format = "vscode://file/{path}:{line}";
    navigate = true;
  };

  programs.gh.enable = true;
  programs.gh.settings.aliases = {
    co = "pr checkout";
  };

  programs.git.enable = true;
  programs.git.signing.key = signingKey;
  programs.git.signing.signByDefault = true;
  programs.git.settings = {
    branch.sort = "-committerdate";
    credential.helper = credentialHelper;
    diff.algorithm = "histogram";
    diff.colorMoved = "zebra";
    diff.mnemonicPrefix = true;
    diff.tool = "difftastic";
    difftool.difftastic.cmd = ''difft "$MERGED" "$LOCAL" "abcdef1" "100644" "$REMOTE" "abcdef2" "100644"'';
    difftool.prompt = false;
    fetch.prune = true;
    gpg.format = "ssh";
    gpg.ssh.program = sshSignProgram;
    help.autocorrect = "prompt";
    init.defaultBranch = "main";
    merge.conflictStyle = "zdiff3";
    pager.difftool = true;
    pull.rebase = true;
    push.autoSetupRemote = true;
    push.default = "simple";
    push.followTags = true;
    rebase.autoStash = true;
    rebase.updateRefs = true;
    rerere.autoUpdate = true;
    rerere.enabled = true;
    user.email = userEmail;
    user.name = userName;
  };
  programs.git.settings.alias = {
    ar = "add .";
    ci = "commit --all";
    d = "diff ':!*.lock'";
    last = "diff --name-status HEAD^!";
    lg = "log --graph --decorate --date=relative --pretty=tformat:'%C(auto)%h%d %s %Cgreen(%ad)%Creset %C(bold blue)<%an>%Creset'";
    root = "rev-parse --show-toplevel";
    s = "status --short";
    unstage = "restore --staged";
    up = "switch";
    view = "!gh repo view --web";
  };
  programs.git.ignores = [
    "**/.DS_Store"
    "**/.idea/*"
    "**/.vscode/*"
  ];

  programs.sapling.enable = true;
  programs.sapling.userName = userName;
  programs.sapling.userEmail = userEmail;
  programs.sapling.extraConfig = {
    pager.pager = "delta";
    gpg.key = signingKey; # Uses `gpg-ssh-sign` shim in pbar1/bin
  };
  programs.sapling.aliases = {
    ar = "addremove";
    d = "diff --exclude=*.lock";
    last = "status --change tip";
    s = "status";
    up = "goto";
    view = "!gh repo view --web";
  };
}
