{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  userName = "Pierce Bartine";
  userEmail = "26949935+pbar1@users.noreply.github.com";
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDim41ofReCgbmijkayBsFg5TlO9qqV8b6Y8Xcwnr49m git";

  credentialHelper = if isDarwin then "osxkeychain" else "libsecret";
  sshSignProgram = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
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
  programs.git.signing.signer = lib.mkIf isDarwin sshSignProgram;
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

  programs.jujutsu.enable = true;
  programs.jujutsu.settings = {
    aliases = {
      d = [ "diff" ];
      push = [
        "git"
        "push"
      ];
      tug = [
        "bookmark"
        "advance"
      ];
      up = [ "edit" ];
      view = [
        "util"
        "exec"
        "--"
        "gh"
        "repo"
        "view"
        "--web"
      ];
    };
    revsets."bookmark-advance-to" = "closest_pushable(@)";
    "revset-aliases"."closest_pushable(to)" =
      ''heads(::to & mutable() & ~description(exact:"") & (~empty() | merges()))'';
    signing.backend = "ssh";
    signing.backends.ssh.program = lib.mkIf isDarwin sshSignProgram;
    signing.behavior = "own";
    signing.key = signingKey;
    ui.default-command = "log";
    user.email = userEmail;
    user.name = userName;
  };
}
