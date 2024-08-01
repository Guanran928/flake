{
  pkgs,
  config,
  lib,
  ...
}: {
  home = {
    username = "guanranwang";
    homeDirectory =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "/Users/${config.home.username}"
      else "/home/${config.home.username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Default applications
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
  home.packages =
    (with pkgs; [
      fd
      fastfetch
    ])
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (with pkgs; [
      trashy
    ]);

  programs.fish.functions = let
    jq = lib.getExe pkgs.jq;
    nix = lib.getExe pkgs.nix;
    curl = lib.getExe pkgs.curl;
  in {
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
