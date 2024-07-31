{
  projectRootFile = "flake.nix";

  ### nix
  programs.deadnix.enable = true;
  programs.statix.enable = true;
  programs.alejandra.enable = true;

  ### misc
  programs.prettier.enable = true;
  settings.formatter.prettier.excludes = [
    "hosts/blacksteel/secrets.yaml"
    "hosts/lightsail-tokyo/secrets.yaml"
    "nixos/profiles/opt-in/mihomo/secrets.yaml"
    "nixos/profiles/opt-in/wireless/secrets.yaml"
    "secrets.yaml"
  ];
}
