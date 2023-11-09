{pkgs, ...}: {
  imports = [./spicetify.nix];
  home.packages = with pkgs; [
    ### Local
    mpv
    amberol

    ### Streaming
    yesplaymusic
    netease-cloud-music-gtk

    ### Misc
    mousai
    cava
    easyeffects
  ];
}
