{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # enable flakes
  programs.command-not-found.enable = false; # Unavailable in Flakes build
}
