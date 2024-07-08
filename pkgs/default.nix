# NOTE: 301: All packages are migrated to `github:Guanran928/nur-packages`,
#       only keeping some packages that only fits for personal use.
pkgs: let
  inherit (pkgs) lib;
in {
  scripts = lib.makeScope pkgs.newScope (self: {
    # util
    makeScript = self.callPackage ./scripts/makeScript.nix {};

    # scripts
    lofi = self.callPackage ./scripts/lofi.nix {};
  });
}
