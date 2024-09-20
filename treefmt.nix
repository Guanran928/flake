{
  projectRootFile = "flake.nix";

  programs = {
    deadnix.enable = true;
    nixfmt.enable = true;
    prettier.enable = true;
    statix.enable = true;
  };

  settings.formatter.nixfmt.options = [ "--strict" ];

  settings.formatter.prettier.excludes = [
    "hosts/pek0/secrets.yaml"
    "hosts/tyo0/secrets.yaml"
    "nixos/profiles/sing-box/secrets.yaml"
    "nixos/profiles/wireless/secrets.yaml"
    "secrets.yaml"
  ];
}
