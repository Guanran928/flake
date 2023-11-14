{pkgs, ...}: {
  imports = [
    ./core.nix

    ### Flakes
    ../../../../flakes/nixos/home-manager.nix
    ../../../../flakes/nixos/berberman.nix
  ];

  ### home-manager
  home-manager.users.guanranwang.imports = [
    ../../home-manager/profiles/command-line/nixos/fancy-stuff.nix
    ../../home-manager/profiles/graphical-stuff/nixos
    ../../home-manager/profiles/media/nixos
    ../../home-manager/modules/terms/alacritty.nix
    ../../home-manager/modules/shell/fish.nix
    ../../home-manager/modules/shell/bash.nix
    ../../home-manager/modules/editor/helix.nix
    ../../home-manager/modules/editor/neovim.nix
    ../../home-manager/modules/editor/vscode.nix
    ../../home-manager/modules/browser/chromium.nix
    ../../home-manager/modules/browser/librewolf.nix
    ../../home-manager/modules/lang/nix.nix
    ../../home-manager/modules/lang/go.nix
    ../../home-manager/modules/wm/sway.nix
  ];

  fonts.enableDefaultPackages = false;
  security.pam.services.swaylock = {};
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };
  services = {
    ratbagd.enable = true;
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
