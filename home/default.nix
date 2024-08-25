{
  lib,
  pkgs,
  ...
}:
{
  home = {
    username = "guanranwang";
    homeDirectory = "/home/guanranwang";
    stateVersion = "23.05";
  };

  imports = [
    ./applications/atuin
    ./applications/bash
    ./applications/bat
    ./applications/eza
    ./applications/fish
    ./applications/git
    ./applications/gpg
    ./applications/neovim
    ./applications/ssh
    ./applications/starship
    ./applications/tealdeer
    ./applications/tmux
  ];

  programs.jq.enable = true;
  programs.ripgrep.enable = true;
  programs.skim.enable = true;
  programs.zoxide.enable = true;
  home.packages = with pkgs; [
    fastfetch
    fd
  ];

  programs.fish.functions =
    let
      jq = lib.getExe pkgs.jq;
      nix = lib.getExe pkgs.nix;
      curl = lib.getExe pkgs.curl;
    in
    {
      "pb" = ''
        ${jq} -Rns '{text: inputs}' | \
          ${curl} -s -H 'Content-Type: application/json' --data-binary @- https://pb.ny4.dev | \
          ${jq} -r '. | "https://pb.ny4.dev\(.path)"'
      '';

      "getmnter" = ''
        ${nix} eval nixpkgs#{$argv}.meta.maintainers --json | \
          ${jq} '.[].github | "@" + .' -r
      '';
    };
}
