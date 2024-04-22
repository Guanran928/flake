{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  home = {
    # for nix-on-droid
    username = lib.mkDefault "guanranwang";
    homeDirectory =
      lib.mkDefault
      (
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/Users/${config.home.username}"
        else "/home/${config.home.username}"
      );

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
    inputs.self.homeManagerModules.default
    inputs.nur.hmModules.nur

    ./applications/atuin
    ./applications/bash
    ./applications/bat
    ./applications/eza
    ./applications/fastfetch
    ./applications/fish
    ./applications/git
    ./applications/gpg
    ./applications/skim
    ./applications/starship
    ./applications/tealdeer
    ./applications/zellij
  ];

  programs.ripgrep.enable = true;
  programs.zoxide.enable = true;
  home.packages = with pkgs; [fd] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (with pkgs; [trashy]);

  home.shellAliases = {
    ".." = "cd ..";
    "farsee" = "curl -F 'c=@-' 'https://fars.ee/'"; # pb
  };
}
