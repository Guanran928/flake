{
  inputs,
  pkgs,
  ...
}: {
  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Disable flake-registry
  # https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry
  nix.settings.flake-registry = "";
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.nixpkgs-stable.flake = inputs.nixpkgs-stable;

  # Install Git
  environment.systemPackages = [pkgs.git];
}
