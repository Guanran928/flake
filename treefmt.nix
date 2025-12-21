{
  projectRootFile = "flake.nix";

  programs = {
    # keep-sorted start
    deadnix.enable = true;
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
    # keep-sorted start block=yes newline_separated=yes
    nixfmt = {
      options = [ "--strict" ];
    };

    prettier.excludes = [
      "**/secrets.yaml"
      "secrets.yaml"
    ];
    # keep-sorted end
  };
}
