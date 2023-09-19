{ lib, pkgs, ... }:

{
  imports = [
    ./networking
    ./packages
    ./users

    ./input.nix
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # Allow unfree applications
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    #"vscode"
    "spotify"
    "keka" # i thought it was opensource
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #neovim
    #vscode
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  #nix.settings.experimental-features = "nix-command flakes";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}