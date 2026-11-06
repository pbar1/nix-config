{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nono
    podman-compose
  ];

  services.podman.enable = true;
  services.podman.useDefaultMachine = false;
  services.podman.machines."podman-machine-default".cpus = 4;
  services.podman.machines."podman-machine-default".memory = 4096;
  services.podman.machines."podman-machine-default".diskSize = 40;
  services.podman.machines."podman-machine-default".autoStart = false;
  services.podman.settings.containers.engine.compose_providers = [
    "${pkgs.podman-compose}/bin/podman-compose"
  ];
}
