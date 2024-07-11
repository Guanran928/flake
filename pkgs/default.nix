# NOTE: 301: All packages are migrated to `github:Guanran928/nur-packages`,
#       only keeping some packages that only fits for personal use.
pkgs: let
  inherit (pkgs) lib callPackage;
in {
  # https://github.com/NixOS/nixpkgs/pull/308720
  pixivfe = callPackage ./pixivfe.nix {};

  scripts = lib.makeScope pkgs.newScope (self: let
    inherit (self) callPackage;
  in {
    # util
    makeScript = callPackage ./scripts/makeScript.nix {};

    # scripts
    lofi = callPackage ./scripts/lofi.nix {};
  });
}
