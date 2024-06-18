{
  lib,
  runtimeShell,
  writeScriptBin,
  runCommandNoCCLocal,
  makeBinaryWrapper,
}: {
  name,
  src,
  runtimeInputs ? [],
}:
# FIXME: incorrect argv0
runCommandNoCCLocal name {
  inherit src;
  nativeBuildInputs = [makeBinaryWrapper];
} ''
  install -Dm755 $src $out/bin/.$name
  makeBinaryWrapper ${runtimeShell} $out/bin/$name \
    --add-flags $out/bin/.$name \
    --prefix PATH : ${lib.makeBinPath runtimeInputs}
''
