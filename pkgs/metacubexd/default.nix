{
  fetchurl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "metacubexd";
  version = "1.134.0";
  src = fetchurl {
    url = "https://github.com/MetaCubeX/metacubexd/releases/download/v${finalAttrs.version}/compressed-dist.tgz";
    hash = "sha256-Xx2UReUAxHg4CrKqGs9vGmWRsosJE1OqnYSmp2wOC9M=";
  };
  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out
    cp -r ./* $out
  '';
})