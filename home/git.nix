{ pkgs, ... }:
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
  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;
  programs.delta.options = {
    hyperlinks = true;
    hyperlinks-file-link-format = "vscode://file/{path}:{line}";
    navigate = true;
  };

  programs.difftastic.enable = true;

  programs.mergiraf.enable = true;
  programs.mergiraf.enableGitIntegration = true;
  programs.mergiraf.enableJujutsuIntegration = true;

  programs.gh.enable = true;
  programs.gh.settings.aliases = {
    co = "pr checkout";
  };

  programs.git.enable = true;
  programs.git.signing.format = "ssh";
  programs.git.signing.key = signingKey;
  programs.git.signing.signer = sshSignProgram;
  programs.git.signing.signByDefault = true;
  programs.git.settings = {
    branch.sort = "-committerdate";
    credential.helper = credentialHelper;
    diff.algorithm = "histogram";
    diff.colorMoved = "zebra";
    diff.mnemonicPrefix = true;
    diff.tool = "difft";
    difftool.difft.cmd = ''difft "$MERGED" "$LOCAL" "abcdef1" "100644" "$REMOTE" "abcdef2" "100644"'';
    difftool.prompt = false;
    fetch.prune = true;
    help.autocorrect = "prompt";
    init.defaultBranch = "main";
    merge.conflictStyle = "diff3"; # Required for mergiraf
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
    dt = "difftool";
    last = "diff --name-status HEAD^!";
    lg = "log --graph --decorate --date=relative --pretty=tformat:'%C(auto)%h%d %s %Cgreen(%ad)%Creset %C(bold blue)<%an>%Creset'";
    root = "rev-parse --show-toplevel";
    showt = "-c diff.external=difft show --ext-diff";
    st = "status --short";
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
    extdiff."cmd.difft" = "difft";
    extensions.extdiff = "";
    gpg.key = signingKey; # Uses `gpg-ssh-sign` shim in pbar1/bin
    pager.pager = "delta";
  };
  programs.sapling.aliases = {
    ar = "addremove";
    d = "diff --exclude=*.lock";
    dt = "difft";
    p = "pull --rebase";
    showt = "difft --change=.";
    sub = "submit";
    submit = "pr submit";
    unstack = "rebase --source=.";
    up = "goto";
    view = "!gh repo view --web";
  };

  programs.jujutsu.enable = true;
  programs.jujutsu.settings = {
    signing.backend = "ssh";
    signing.backends.ssh.program = sshSignProgram;
    signing.behavior = "own";
    signing.key = signingKey;
    ui.default-command = "log";
    user.email = userEmail;
    user.name = userName;
  };
}
