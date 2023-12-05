{pkgs, ...}: {
  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Disable nix-channel
  nix.channel.enable = false;

  # Install Git
  environment.systemPackages = [pkgs.git];

  # Does not work with Flake based configurations
  system.copySystemConfiguration = false;
  programs.command-not-found.enable = false;
}
