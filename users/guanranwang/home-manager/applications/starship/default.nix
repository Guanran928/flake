{
  lib,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    settings = lib.mkMerge [
      {
        add_newline = false;
        line_break.disabled = true;

        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[>](bold red)";
          vimcmd_symbol = "[<](bold green)";
          vimcmd_replace_one_symbol = "[<](bold purple)";
          vimcmd_replace_symbol = "[<](bold purple)";
          vimcmd_visual_symbol = "[<](bold yellow)";
        };
      }
      (builtins.fromTOML (builtins.readFile "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml"))
    ];
  };
}
