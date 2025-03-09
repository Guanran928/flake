{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-latest;
    profiles.default = {
      isDefault = true;
      extraConfig = ''
        ${builtins.readFile (
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/HorlogeSkynet/thunderbird-user.js/refs/tags/v128.0/user.js";
            sha256 = "129d22m4ls40njcil2wsjmv8xszpvhpr4bgx2wdnx8vndrq16msp";
          }
        )}
        ${builtins.readFile ./user-overrides.js}
      '';
    };
  };
}
