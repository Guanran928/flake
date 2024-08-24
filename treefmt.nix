{
  projectRootFile = "flake.nix";

  ### nix
  programs.alejandra.enable = true;
  programs.deadnix.enable = true;
  programs.statix.enable = true;

  ### misc
  programs.prettier.enable = true;
  settings.formatter.prettier.excludes = [
    "hosts/blacksteel/secrets.yaml"
    "hosts/tyo0/secrets.yaml"
    "nixos/profiles/sing-box/secrets.yaml"
    "nixos/profiles/wireless/secrets.yaml"
    "secrets.yaml"
  ];
}
