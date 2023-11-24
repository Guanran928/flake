{pkgs, ...}: {
  imports = [./spicetify.nix];
  programs.mpv.enable = true;
  home.packages = with pkgs; [
    # Music & Video
    ### Local
    amberol

    ### Streaming
    yesplaymusic
    netease-cloud-music-gtk

    ### Misc
    mousai
    cava
    easyeffects

    # Photos
    loupe
  ];
}
