{
  projectRootFile = "flake.nix";

  programs = {
    deadnix.enable = true;
    nixfmt.enable = true;
    prettier.enable = true;
    statix.enable = true;
    terraform.enable = true;
  };

  settings.formatter.nixfmt.options = [ "--strict" ];

  settings.formatter.prettier.excludes = [
    "**/secrets.yaml"
    "infra/data.json"
  ];
}
