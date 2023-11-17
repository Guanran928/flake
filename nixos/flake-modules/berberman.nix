{
  inputs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    inputs.berberman.overlays.default
  ];
  nix.settings = {
    substituters = lib.mkAfter ["https://berberman.cachix.org"];
    trusted-public-keys = ["berberman.cachix.org-1:UHGhodNXVruGzWrwJ12B1grPK/6Qnrx2c3TjKueQPds="];
  };
}