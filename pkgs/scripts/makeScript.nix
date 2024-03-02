# trimmed down version of writeShellApplication
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/trivial-builders/default.nix#L245
{
  lib,
  runtimeShell,
  writeScriptBin,
}: {
  name,
  file,
  runtimeInputs ? [],
}:
writeScriptBin name ''
  #!${runtimeShell}
  ${lib.optionalString (runtimeInputs != []) ''export PATH="${lib.makeBinPath runtimeInputs}:$PATH"''}
  ${builtins.readFile file}
''
