{pkgs, ...}: {
  home = {
    username = "guanranwang";
    homeDirectory = "/home/guanranwang";

    packages =
      (with pkgs; [
        # gui
        gparted
        timeshift

        ### matrix
        #fluffychat
        element-desktop
        cinny-desktop
        #nheko

        ### misc
        bitwarden
        #discord
        #qq
        tuba
        protonup-qt
        piper
        telegram-desktop
        qbittorrent
        gradience
        dippi
        obs-studio
        gnome.seahorse
        gnome.file-roller
        gnome.gnome-weather
        gnome.gnome-calculator
        gnome.dconf-editor

        # TUI
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

  services.ssh-agent.enable = true;

  #programs.boxxy = {
  #  enable = true;
  #  #rules = {
  #  #
  #  #};
  #};
}
