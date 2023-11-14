{pkgs, ...}: {
  home.packages =
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
      #gparted
      #timeshift
      #tuba
      #piper
      #gradience
      #dippi
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

  programs = {
    obs-studio.enable = true;
  };

  services = {
    ssh-agent.enable = true;
  };

  #programs.boxxy = {
  #  enable = true;
  #  #rules = {
  #  #
  #  #};
  #};
}
