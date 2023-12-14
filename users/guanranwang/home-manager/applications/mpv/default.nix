{
  pkgs,
  lib,
  ...
}: {
  programs.mpv = {
    enable = true;
    config = {
      ao = "pipewire,";
      vo = "gpu-next,gpu,";

      hwdec = "auto-safe";
      profile = "gpu-hq";
      osc = "no";
    };
    scripts = with pkgs.mpvScripts;
      [
        thumbfast
      ]
      ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) (with pkgs.mpvScripts; [
        mpris
      ]);
  };

  # for scripts that is not in nixpkgs
  xdg.configFile = let
    modernX = pkgs.fetchFromGitHub {
      owner = "zydezu";
      repo = "modernX";
      rev = "10f74d29f86cbfb307181ecfa564402f993b073d";
      hash = "sha256-ozbOsVGdllB+E4UtERynhe5Eng3nKnL/IIEtT4yVdOI=";
    };
  in {
    "mpv/scripts/modernx.lua".source = "${modernX}/modernx.lua";
    "mpv/fonts/Material-Design-Iconic-Font.ttf".source = "${modernX}/Material-Design-Iconic-Font.ttf";
    "mpv/fonts/Material-Design-Iconic-Round.ttf".source = "${modernX}/Material-Design-Iconic-Round.ttf";
  };
}
