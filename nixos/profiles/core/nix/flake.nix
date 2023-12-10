{
  pkgs,
  inputs,
  ...
}: {
  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Disable nix-channel
  nix.channel.enable = false;

  # Disable flake-registry
  # https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry
  nix.settings.flake-registry = "";
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.nixpkgs-stable.flake = inputs.nixpkgs-stable;

  # Install Git
  environment.systemPackages = [pkgs.git];

  # Does not work with Flake based configurations
  system.copySystemConfiguration = false;
  programs.command-not-found.enable = false;
}
