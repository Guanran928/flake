# NOTE: 301: All packages are migrated to `github:Guanran928/nur-packages`,
#       only keeping some packages that only fits for personal use.
pkgs: {
  scripts = rec {
    # util
    makeScript = pkgs.callPackage ./scripts/makeScript.nix {};

    # scripts
    # TODO: Do I really have to inherit `makeScript` for every script?
    # NOTE: ./scripts/_bin/* is unused, I probably should to remove them.
    lofi = pkgs.callPackage ./scripts/lofi.nix {inherit makeScript;};
    screenshot = pkgs.callPackage ./scripts/screenshot.nix {inherit makeScript;};
  };
}
