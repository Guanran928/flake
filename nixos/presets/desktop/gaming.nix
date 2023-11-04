{pkgs, ...}: {
  programs.gamemode = {
    enable = true;
    settings.custom = {
      start = "${pkgs.libnotify}/bin/notify-send 'GameMode Activated' 'GameMode Activated! Enjoy enhanced performance. 🚀'";
      end = "${pkgs.libnotify}/bin/notify-send 'GameMode Deactivated' 'GameMode Deactivated. Back to normal mode. ⏹️'";
    };
  };
}
