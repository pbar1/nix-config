{
  lib,
  stdenv,
  bash,
  jq,
  makeWrapper,
  src,
}:

let
  marketplaceJson = builtins.fromJSON (builtins.readFile "${src}/.claude-plugin/marketplace.json");

  plugin = builtins.elemAt marketplaceJson.plugins 0;

  pname = plugin.name or "starship-claude";

  version = plugin.version or "1.0.0";
in
stdenv.mkDerivation {
  inherit pname version src;

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    bash
    jq
  ];

  installPhase = ''
    mkdir -p $out/bin 
    cp plugin/bin/starship-claude $out/bin/starship-claude
    chmod +x $out/bin/starship-claude
    wrapProgram $out/bin/starship-claude \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          jq
        ]
      }
  '';
}
