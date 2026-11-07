{ pkgs, nixos }:
pkgs.dockerTools.buildLayeredImage {
  name = "ghcr.io/pbar1/nixos-container";
  tag = "latest";
  contents = [ nixos ];
  includeNixDB = true;

  extraCommands = ''
    # Activation populates /etc; Kubernetes supplies bind-mounted network files.
    rm etc
    mkdir -p etc nix/var/nix/profiles root run tmp var
    ln -s ${nixos} nix/var/nix/profiles/system
    chmod 1777 tmp
  '';

  config.Entrypoint = [ "/init" ];
  config.Env = [
    "container=oci"
    "PATH=/run/wrappers/bin:/run/current-system/sw/bin"
  ];
  config.Labels."org.opencontainers.image.source" = "https://github.com/pbar1/nix-config";
}
