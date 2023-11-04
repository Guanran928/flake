{ pkgs, ... }:

{
  home.packages = with pkgs; [
    steam
    #lunar-client
    prismlauncher
    osu-lazer-bin
  ];

  programs.mangohud = {
    enable = true;
    # TODO: add configuration, i have no idea how to display stuff with nix syntax
  };
}