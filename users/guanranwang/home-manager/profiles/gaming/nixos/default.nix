{pkgs, ...}: {
  home.packages = with pkgs; [
    ### Games
    steam
    osu-lazer-bin
    prismlauncher
    #lunar-client

    ### Tools
    protonup-qt
  ];

  programs.mangohud = {
    enable = true;
    # TODO: add configuration, i have no idea how to display stuff with nix syntax
  };
}
