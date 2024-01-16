{
  pkgs,
  lib,
  inputs,
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
      ])
      ++ (with inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mpvScripts; [
        modernx
      ])
      ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) (with pkgs.mpvScripts; [
        mpris
      ]);
  };

  # I dont know how to handle the font
  xdg.configFile = with inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mpvScripts; {
    "mpv/fonts/Material-Design-Iconic-Font.ttf".source = "${modernx}/share/mpv/fonts/Material-Design-Iconic-Font.ttf";
    "mpv/fonts/Material-Design-Iconic-Round.ttf".source = "${modernx}/share/mpv/fonts/Material-Design-Iconic-Round.ttf";
  };
}
