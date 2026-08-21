{ inputs, pkgs }:

let
  home = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs.inputs = inputs;
    modules = [
      ../home
      {
        home.file.".bash_profile".text = ''
          case $- in
            *i*) exec "$HOME/.nix-profile/bin/fish" ;;
          esac
        '';
        home.username = "agent";
        home.uid = 1000;
        home.homeDirectory = "/home/agent";
        home.stateVersion = "22.05";
      }
    ];
  };

  baseImage = pkgs.dockerTools.pullImage {
    imageName = "docker/sandbox-templates";
    imageDigest = "sha256:1e642f7fadebcbff3d8de67114e9b42a5971ba9b4287ebffa1d05662f5a0f5ec";
    hash = "sha256-YDo8mlZa8kL6iW1tF3W+M2uSMMRTxsovs0YDGPB3SDY=";
    finalImageName = "pbar/sbx-home";
    finalImageTag = "latest";
    arch = "arm64";
  };

  sandboxEnvironment = pkgs.writeText "sandbox-persistent.sh" ''
    export PATH="/home/agent/.nix-profile/bin:$PATH"
    . /home/agent/.nix-profile/etc/profile.d/hm-session-vars.sh
  '';

  imageRoot = pkgs.runCommand "pbar-home-root" { } ''
    mkdir -p $out/home/agent $out/etc
    cp -r --no-preserve=mode,ownership ${home.config.home-files}/. $out/home/agent/
    ln -s ${home.config.home.path} $out/home/agent/.nix-profile
    install -m 0644 ${sandboxEnvironment} $out/etc/sandbox-persistent.sh
  '';
in
pkgs.dockerTools.buildLayeredImage {
  name = "pbar-home";
  tag = "latest";
  compressor = "none";
  architecture = "arm64";
  fromImage = baseImage;
  contents = imageRoot;

  fakeRootCommands = ''
    chown -hR 1000:1000 home/agent
    chown 1000:1000 etc/sandbox-persistent.sh
  '';

  config.User = "agent";
  config.Labels = {
    "com.docker.sandboxes" = "templates";
    "com.docker.sandboxes.base" = "ubuntu:questing";
    "com.docker.sandboxes.flavor" = "shell";
  };
}
