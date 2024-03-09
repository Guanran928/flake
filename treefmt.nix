{
  projectRootFile = "flake.nix";

  ### nix
  programs.deadnix.enable = true;
  programs.statix.enable = true;
  programs.alejandra.enable = true;

  ### shell
  programs.shellcheck.enable = true;
  programs.shfmt.enable = true;

  ### toml
  programs.taplo.enable = true;

  ### misc
  programs.prettier.enable = true;
  settings.formatter.prettier.excludes = ["secrets.yaml"];
}
