{
  lib,
  runtimeShell,
  runCommandLocal,
  makeBinaryWrapper,
}: {
  name,
  src,
  runtimeInputs ? [],
}:
# FIXME: incorrect argv0
runCommandLocal name {
  inherit src;
  nativeBuildInputs = [makeBinaryWrapper];
  meta.mainProgram = name;
} ''
  install -Dm755 $src $out/bin/.$name
  makeBinaryWrapper ${runtimeShell} $out/bin/$name \
    --add-flags $out/bin/.$name \
    --prefix PATH : ${lib.makeBinPath runtimeInputs}
''
