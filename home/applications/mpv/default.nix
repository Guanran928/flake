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

      alang = "jpn,ja";
      slang = "eng,en";
    };
    scripts =
      (with pkgs.mpvScripts; [
        thumbfast
        sponsorblock
        modernx-zydezu
      ])
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (with pkgs.mpvScripts; [
        mpris
      ]);
  };
}
