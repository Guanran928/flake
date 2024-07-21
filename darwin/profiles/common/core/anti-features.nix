{lib, ...}: {
  # Allow unfree applications
  nixpkgs.config.allowUnfreePredicate = pkg:
    lib.elem (lib.getName pkg) [
      "keka"
    ];
}
