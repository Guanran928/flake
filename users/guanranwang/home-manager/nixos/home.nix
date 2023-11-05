{pkgs, ...}: {
  home = {
    username = "guanranwang";
    homeDirectory = "/home/guanranwang";

    packages =
      (with pkgs; [
        # gui
        gparted
        timeshift
        mpv
        spicetify-cli

        ### matrix
        #fluffychat
        element-desktop
        cinny-desktop
        #nheko

        ### music
        easyeffects
        spotify
        yesplaymusic
        amberol
        netease-cloud-music-gtk

        ### misc
        bitwarden
        #discord
        #qq
        tuba
        mousai
        protonup-qt
        piper
        telegram-desktop
        qbittorrent
        gradience
        dippi
        obs-studio
        gnome.seahorse
        gnome.eog
        gnome.file-roller
        gnome.gnome-weather
        gnome.gnome-calculator
        gnome.dconf-editor

        # TUI
        cava
        joshuto # rs
        bottom
        helix
        skim
        bat

        # cli
        fastfetch
        wget
        sops
        skim
        ydict
        nix-output-monitor
        zoxide # rs
        trashy
        eza
        ripgrep
        fd
        freshfetch
        hyperfine

        # lsp
        nil
        gopls
        libclang
      ])
      ++ (with pkgs.gnome; [
        # GNOME
        nautilus
        zenity

        # GNOME only
        #gnome-tweaks
        #gnome-software
        #gnome-shell-extensions
      ])
      ++ (with pkgs.gnomeExtensions; [
        # GNOME extensions
        #arcmenu
        #appindicator
        #blur-my-shell
        #caffeine
        #dash-to-panel
        #dash-to-dock
        #gamemode # outdated
        #just-perfection
        #kimpanel
      ]);
  };

  wayland.windowManager = {
    hyprland = {
      #enable = true;
      enableNvidiaPatches = true;
      xwayland.enable = true;
      plugins = [
        #inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
      ];

      extraConfig = ''
        #source = ~/.config/hypr/themes/mocha.conf
        #source = ~/.config/hypr/themes/colors.conf
        #source = ~/.config/hypr/plugins.conf
        source = ~/.config/hypr/main.conf
        source = ~/.config/hypr/keybinds.conf
        source = ~/.config/hypr/autostart.conf
        source = ~/.config/hypr/env.conf
      '';
    };
  };

  #xsession = {
  #  enable = true;
  #  windowManager.bspwm = {
  #    enable = true;
  #  };
  #};

  #programs.boxxy = {
  #  enable = true;
  #  #rules = {
  #  #
  #  #};
  #};
}
