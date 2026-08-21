{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.pierce.imports = [
    ../home
    ../home/ghostty.nix
    ../home/vscode.nix
    ../home/wezterm
  ];
}
