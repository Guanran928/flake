{
  projectRootFile = "flake.nix";

  programs = {
    deadnix.enable = true;
    just.enable = true;
    nixfmt.enable = true;
    prettier.enable = true;
    statix.enable = true;
    terraform.enable = true;
  };

  settings.formatter.nixfmt.options = [ "--strict" ];

  settings.formatter.just.includes = [ "infra/justfile" ];

  settings.formatter.prettier.excludes = [
    "**/secrets.yaml"
    "infra/data.json"
    "secrets.yaml"
  ];
}
