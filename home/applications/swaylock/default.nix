{ inputs, pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      show-failed-attempts = true;
      show-keyboard-layout = true;
      image = toString inputs.self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.background;
      scaling = "fill";
    };
  };
}
