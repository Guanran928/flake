{pkgs, ...}: {
  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Install Git
  environment.systemPackages = [pkgs.git];

  # Does not work with Flake based configurations
  system.copySystemConfiguration = false;
  programs.command-not-found.enable = false;
}
