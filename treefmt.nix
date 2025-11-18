{
  projectRootFile = "flake.nix";

  programs = {
    # keep-sorted start
    deadnix.enable = true;
    just.enable = true;
    keep-sorted.enable = true;
    nixfmt.enable = true;
    prettier.enable = true;
    statix.enable = true;
    stylua.enable = true;
    taplo.enable = true;
    terraform.enable = true;
    # keep-sorted end
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
