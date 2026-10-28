inputs: [
  inputs.nix-vscode-extensions.overlays.default

  (final: prev: {
    gvisor =
      (prev.gvisor.override {
        buildGoModule = final.buildGo127Module;
      }).overrideAttrs (old: {
        src = inputs.gvisor;
        version = "20261026.0";
        vendorHash = "sha256-Hk9wHVoaRmYXsKZNa7hy+Alstf6iUCP8zccZO4MKfjc=";
        # The newer generated source supersedes nixpkgs' go.mod patch.
        patches = [ ];
        subPackages = old.subPackages ++ [
          "runsc/cmd/sentry"
          "runsc/cmd/metricserver"
          "runsc/checkpointgofer"
        ];
        nativeBuildInputs = old.nativeBuildInputs ++ [ final.stdenv.cc ];
        # Upstream's C helpers are freestanding static executables without libc.
        hardeningDisable = [
          "pic"
          "stackprotector"
          "fortify"
        ];
        postInstall = old.postInstall + ''
          mkdir -p $out/bin/gvisor-bin
          mv $out/bin/sentry $out/bin/gvisor-bin/gvisor_sentry
          mv $out/bin/metricserver $out/bin/gvisor-bin/runsc-metric-server
          mv $out/bin/checkpointgofer $out/bin/gvisor-bin/checkpointgofer
          for helper in prewarmer fdparking procumounter; do
            case "$helper" in
              prewarmer) binary=gvisor-sentry-prewarmer ;;
              fdparking) binary=runsc-fd-parking ;;
              procumounter) binary=gvisor-proc-umounter ;;
            esac
            $CC -Os -ffreestanding -fno-pie -fno-sanitize=all \
              -fno-stack-protector -fno-asynchronous-unwind-tables -fno-unwind-tables \
              -static -nostdlib -nostartfiles -Wl,--build-id=none -Wl,--gc-sections \
              -Wl,-s -Wl,-n -o "$out/bin/gvisor-bin/$binary" "runsc/$helper/$helper.c"
          done
        '';
      });

    # Neovim plugins auto-populated from flake inputs with `nvim:` hasPrefix
    myNvimPlugins =
      with final.lib;
      with attrsets;
      with strings;
      mapAttrs' (
        name: value:
        nameValuePair (removePrefix "nvim:" name) (
          final.vimUtils.buildVimPlugin {
            pname = removePrefix "nvim:" name;
            src = value.outPath;
            version = value.rev;
          }
        )
      ) (filterAttrs (name: _: hasPrefix "nvim:" name) inputs);

    nvim-pbar = final.callPackage ./pkgs/nvim {
      nixvim = inputs.nixvim.legacyPackages.${final.stdenv.hostPlatform.system};
    };
  })
]
