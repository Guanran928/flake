{pkgs, ...}: {
  imports = [./spicetify.nix];
  programs.mpv.enable = true;
  home.packages = with pkgs; [
    ### Streaming
    spotify
    yesplaymusic
  ];
}
