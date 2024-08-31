{
  projectRootFile = "flake.nix";

  ### nix
  programs.nixfmt.enable = true;
  programs.deadnix.enable = true;
  programs.statix.enable = true;

  ### misc
  programs.prettier.enable = true;
  settings.formatter.prettier.excludes = [
    "hosts/pek0/secrets.yaml"
    "hosts/tyo0/secrets.yaml"
    "nixos/profiles/sing-box/secrets.yaml"
    "nixos/profiles/wireless/secrets.yaml"
    "secrets.yaml"
  ];
}
