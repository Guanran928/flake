{
  pkgs,
  inputs,
  config,
  ...
}: {
  home.packages = [
    (inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable.override {
      location = "${config.xdg.dataHome}/osu-stable";
    })
  ];
}
