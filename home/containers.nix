{ pkgs, ... }:

let
  toJson = obj: (pkgs.formats.json { }).generate "dummy" obj;
in

{
  home.packages = with pkgs; [
    nono
    podman-compose
  ];

  xdg.configFile."nono/profiles/digitalocean.json".source = toJson {
    meta.name = "digitalocean";
    network.credentials = [ "digitalocean" ];
    network.custom_credentials.digitalocean = {
      upstream = "https://api.digitalocean.com";
      credential_key = "digitalocean_api_token";
      env_var = "DIGITALOCEAN_TOKEN";
      inject_header = "Authorization";
      credential_format = "Bearer {}";
    };
  };

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
