{
  pkgs,
  lib,
  ...
}: {
  ### Options
  myFlake.nixos.boot.noLoaderMenu = lib.mkDefault true;

  ### sops-nix
  sops.secrets."wireless/home".path = "/var/lib/iwd/wangxiaobo.psk"; # Home wifi password

  ### home-manager
  home-manager.users.guanranwang = import ./home;

  fonts.enableDefaultPackages = false;
  security.pam.services.swaylock = {};
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    config = {
      common.default = [
        "gtk"
      ];
      sway.default = [
        "wlr"
        "gtk"
      ];
    };
  };
  services = {
    gvfs.enable = true;
    gnome = {
      sushi.enable = true;
      gnome-online-accounts.enable = true;
    };
  };
  programs = {
    kdeconnect = {
      enable = true;
      #package = pkgs.gnomeExtensions.gsconnect;
      package = pkgs.valent;
    };
  };
  services.xserver.libinput = {
    touchpad = {
      accelProfile = "flat";
      naturalScrolling = true;
      middleEmulation = false;
    };
    mouse = {
      accelProfile = "flat";
      naturalScrolling = true;
      middleEmulation = false;
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
