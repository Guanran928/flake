{
  projectRootFile = "flake.nix";

  programs = {
    deadnix.enable = true;
    just.enable = true;
    nixfmt.enable = true;
    prettier.enable = true;
    statix.enable = true;
    terraform.enable = true;
    stylua.enable = true;
    taplo.enable = true;
  };

  settings.formatter = {
    nixfmt = {
      options = [ "--strict" ];
    };

    just = {
      includes = [ "infra/justfile" ];
    };

    prettier.excludes = [
      "**/secrets.yaml"
      "infra/data.json"
      "secrets.yaml"
    ];
  };
}
