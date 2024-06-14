{lib, ...}: {
  # Allow unfree applications
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "keka"
    ];
}
