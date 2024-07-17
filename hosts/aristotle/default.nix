{pkgs, ...}: {
  imports = [
    ../../nixos/profiles/opt-in/mihomo
    ../../nixos/profiles/opt-in/wireless

    ./anti-feature.nix
    ./disko.nix
    ./graphical
    ./hardware-configuration.nix
    ./impermanence.nix
    ./lanzaboote.nix
  ];

  networking.hostName = "aristotle";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "23.11";

  home-manager.users.guanranwang = import ./home;

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    yubikey-manager
    localsend
  ];

  networking.firewall.allowedTCPPorts = [53317];
  networking.firewall.allowedUDPPorts = [53317];

  programs.adb.enable = true;
  programs.anime-game-launcher.enable = true;
  programs.seahorse.enable = true;
  programs.steam.enable = true;
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };

  services.power-profiles-daemon.enable = true;
  services.gvfs.enable = true;
  services.gnome = {
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = true;
    sushi.enable = true;
  };

  # https://wiki.archlinux.org/title/Gamepad#Connect_Xbox_Wireless_Controller_with_Bluetooth
  hardware.xone.enable = true; # via wired or wireless dongle
  hardware.xpadneo.enable = true; # via Bluetooth

  # yubikey
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];

  # polkit
  security.polkit.enable = true;
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

  fonts.enableDefaultPackages = false;
  security.pam.services.swaylock = {};
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    # https://gitlab.archlinux.org/archlinux/packaging/packages/sway/-/blob/main/sway-portals.conf
    config."sway" = {
      default = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
      "org.freedesktop.impl.portal.Inhibit" = "none";
    };
  };

  ### Removes debounce time
  # https://www.reddit.com/r/linux_gaming/comments/ku6gth
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Never Debounce]
    MatchUdevType=mouse
    ModelBouncingKeys=1
  '';
}
