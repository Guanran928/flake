{pkgs, ...}: {
  home.shellAliases = {
    "yd" = "ydict -c";
  };
  home.packages = with pkgs; [
    ### Fancy stuff
    fastfetch
    freshfetch
    ydict
    yt-dlp
    aria2
    android-tools
  ];
}
