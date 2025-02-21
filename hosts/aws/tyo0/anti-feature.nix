{ lib, ... }:
{
  nixpkgs.config = {
    allowNonSourcePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        "cargo-bootstrap"
        "go"
        "keycloak"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "temurin-bin"
      ];
  };
}
