{
  projectRootFile = "flake.nix";

  ### nix
  programs.deadnix.enable = true;
  programs.statix.enable = true;
  programs.alejandra.enable = true;

  ### shell
  programs.shfmt.enable = true;
  settings.formatter.shfmt.options = ["-i" "2" "-sr"];
  programs.shellcheck.enable = true;
  settings.formatter.shellcheck.options = [
    "-s"
    "bash"
    "-e"
    "SC2016" # shfmt kept doing it, didn't find a toggle to turn it off
  ];

  ### toml
  programs.taplo.enable = true;

  ### misc
  programs.prettier.enable = true;
  settings.formatter.prettier.excludes = [
    "secrets.yaml"
    "hosts/blacksteel/secrets.yaml"
    "hosts/lightsail-tokyo/secrets.yaml"
  ];
}
