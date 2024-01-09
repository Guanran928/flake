{pkgs, ...}: {
  # plymouth
  boot.plymouth.enable = true;

  # xserver
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [xterm];
    displayManager.startx.enable = true;
  };

  # gnome keyring
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # polkit
  security.polkit.enable = true;
  environment.systemPackages = with pkgs; [polkit_gnome];
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
