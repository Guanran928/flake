{
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  # import the flake's module for your system
  imports = [inputs.spicetify-nix.homeManagerModule];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      keyboardShortcut
    ];
  };
}
