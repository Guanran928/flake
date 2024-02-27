{
  pkgs,
  lib,
  config,
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
    scripts =
      (with pkgs.mpvScripts; [
        thumbfast
        sponsorblock
      ])
      ++ (with config.nur.repos.guanran928.mpvScripts; [
        modernx
      ])
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (with pkgs.mpvScripts; [
        mpris
      ]);
  };

  # I dont know how to handle the font
  xdg.configFile = with config.nur.repos.guanran928.mpvScripts; {
    "mpv/fonts/Material-Design-Iconic-Font.ttf".source = "${modernx}/share/mpv/fonts/Material-Design-Iconic-Font.ttf";
    "mpv/fonts/Material-Design-Iconic-Round.ttf".source = "${modernx}/share/mpv/fonts/Material-Design-Iconic-Round.ttf";
  };
}
