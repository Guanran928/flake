# NOTE: 301: All packages are migrated to `github:Guanran928/nur-packages`,
#       only keeping some packages that only fits for personal use.
pkgs:
let
  inherit (pkgs) callPackage;
in
{
  # https://github.com/NixOS/nixpkgs/pull/308720
  pixivfe = callPackage ./pixivfe.nix { };

  background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src;
}
