{ lib, ... }:
{
  nixpkgs.config = {
    allowNonSource = false;
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

    allowUnfree = false;
    allowUnfreePredicate =
      pkg:
      lib.elem (lib.getName pkg)
        [
        ];

    permittedInsecurePackages = [
      "cinny-4.1.0"
      "cinny-unwrapped-4.1.0"
    ];
  };
}
