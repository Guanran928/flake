{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "v2ray-rules-dat";
  version = "202402042209";

  srcs = [
    (fetchurl {
      url = "https://github.com/Loyalsoldier/${finalAttrs.pname}/releases/download/${finalAttrs.version}/geoip.dat";
      hash = "sha256-85OXgvpCa7qLzYGaX+YLMDTPBGvZaMpb1INOFnGM1Tw=";
    })
    (fetchurl {
      url = "https://github.com/Loyalsoldier/${finalAttrs.pname}/releases/download/${finalAttrs.version}/geosite.dat";
      hash = "sha256-XP9X0l6E9cbvc8AS9yW0mBIyDXfjrV0nxB2tkBHDOFE=";
    })
  ];

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    install -Dm644 ${builtins.elemAt finalAttrs.srcs 0} $out/share/v2ray/geoip.dat
    install -Dm644 ${builtins.elemAt finalAttrs.srcs 1} $out/share/v2ray/geosite.dat
  '';

  meta = with lib; {
    description = "Enhanced edition of V2Ray rules dat files";
    homepage = "https://github.com/Loyalsoldier/v2ray-rules-dat";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
})
