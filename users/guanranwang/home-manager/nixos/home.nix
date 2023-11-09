{pkgs, ...}: {
  home = {
    username = "guanranwang";
    homeDirectory = "/home/guanranwang";

    packages =
      (with pkgs; [
        # Messaging
        ### Matrix
        neochat # kinda buggy with window resizing, but it works and its not electron
        #nheko # wont let me login for some reason
        #fractal # does not work with Mozilla's SAML login

        ##                 # vvv 3 UI libraries I dislike vvv
        #cinny-desktop #   # Tauri
        #element-desktop # # Electron
        #fluffychat #      # Flutter

        ### Misc
        telegram-desktop
        #discord
        #qq

        # Misc
        bitwarden
        obs-studio
        gparted
        timeshift
        #tuba
        #piper
        #gradience
        #dippi

        ### Terminal
        # TUI
        joshuto
        bottom
        helix
        skim
        bat

        # CLI
        sops
        nix-output-monitor
        fastfetch
        wget
        ydict
        skim
        fd
        ripgrep
        eza
        zoxide
        trashy
        freshfetch
        hyperfine
      ])
      ++ (with pkgs.gnome; [
        nautilus
        zenity
        seahorse
        file-roller
        gnome-weather
        gnome-calculator
        dconf-editor
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
