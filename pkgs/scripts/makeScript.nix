{
  lib,
  runtimeShell,
  writeScriptBin,
  runCommandNoCCLocal,
  makeBinaryWrapper,
}: {
  name,
  file,
  runtimeInputs ? [],
}:
# FIXME: incorrect argv0
runCommandNoCCLocal name {
  src = file;
  nativeBuildInputs = [makeBinaryWrapper];
} ''
  install -Dm755 $src $out/bin/.$name
  makeBinaryWrapper ${runtimeShell} $out/bin/$name \
    --add-flags $out/bin/.$name \
    --prefix PATH : ${lib.makeBinPath runtimeInputs}
''
