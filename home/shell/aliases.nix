{ pkgs, ... }:

{
  cat = "bat";
  copy = if pkgs.stdenv.hostPlatform.isDarwin then "pbcopy" else "wl-copy --trim-newline";
  l = "eza --header --all --long --git";
  ls = "eza";
  tree = "eza --tree";
}
