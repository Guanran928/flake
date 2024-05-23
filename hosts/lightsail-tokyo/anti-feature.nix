{lib, ...}: {
  nixpkgs.config = {
    allowNonSource = false;
    allowNonSourcePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "adoptopenjdk-hotspot-bin"
        "cargo-bootstrap"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "keycloak"
        "temurin-bin"
      ];

    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
      ];
  };
}
