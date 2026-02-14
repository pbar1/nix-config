# WARNING: Abbreviations with single quotes will break zsh-abbr!
{
  "," = "nix-shell --packages";
  c = "clear";
  cb = "cargo build";
  cr = "cargo run";
  ct = "cargo test";
  cx = "codex";
  dyf = "dyff between -b";
  e = "$EDITOR";
  g = "git";
  gs = "git status --short";
  k = "kubectl";
  kapi = "kubectl api-resources";
  kge = "kubectl get events --watch";
  kgg = "kubectl get pods,replicasets,deployments,statefulsets,daemonsets,jobs,cronjobs";
  kgi = "kubectl get ingresses,services,endpoints,certificates,certificaterequests,certificatesigningrequests,challenges,orders";
  kgn = "kubectl get namespaces --show-labels";
  kgp = "kubectl get pods";
  kns = "kubens";
  ksec = "kubectl sec";
  ktp = "kubectl top pod --sort-by=cpu";
  kubeconfig = "kubectl config view --minify --flatten";
  kx = "kubectx";
  kxx = "kubectl xx";
  lt = "eza --tree";
  nc = "ncat";
  nv = "nvim";
  oc = "opencode";
  s = "sl";
  t = "task";
  tf = "terraform";
  wkgp = "watch kubectl get pods";
  wo = "type --all --short --path";
  xi = "xargs -I {}";
}
