{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "metacubexd";
  version = "1.134.0";

  src = fetchurl {
    url = "https://github.com/MetaCubeX/metacubexd/releases/download/v${finalAttrs.version}/compressed-dist.tgz";
    hash = "sha256-Xx2UReUAxHg4CrKqGs9vGmWRsosJE1OqnYSmp2wOC9M=";
  };

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out
    cp -r ./* $out
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Clash.Meta Dashboard, The Official One, XD";
    homepage = "https://github.com/MetaCubeX/metacubexd";
    license = licenses.mit;
    platforms = platforms.all;
  };
})
