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

        ### matrix
        #fluffychat
        element-desktop
        cinny-desktop
        #nheko

        ### music
        easyeffects
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
      ])
      ++ (with pkgs.gnome; [
        # GNOME
        nautilus
        zenity

        # GNOME only
        #gnome-tweaks
        #gnome-software
        #gnome-shell-extensions
      ]);
  };

  #programs.boxxy = {
  #  enable = true;
  #  #rules = {
  #  #
  #  #};
  #};
}
