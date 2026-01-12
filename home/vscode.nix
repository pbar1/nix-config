{ pkgs, ... }:
{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscodium;
  programs.vscode.profiles.default.extensions = with pkgs; [
    vscode-marketplace.rust-lang.rust-analyzer
  ];
}
