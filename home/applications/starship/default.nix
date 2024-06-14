{
  pkgs,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    settings = lib.importTOML "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml";
  };
}
