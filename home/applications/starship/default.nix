{pkgs, ...}: {
  programs.starship = {
    enable = true;
    settings =
      {
        #add_newline = false;
        #line_break.disabled = true;

        #character = {
        #  success_symbol = "[>](bold green)";
        #  error_symbol = "[>](bold red)";
        #  vimcmd_symbol = "[<](bold green)";
        #  vimcmd_replace_one_symbol = "[<](bold purple)";
        #  vimcmd_replace_symbol = "[<](bold purple)";
        #  vimcmd_visual_symbol = "[<](bold yellow)";
        #};
      }
      // builtins.fromTOML (builtins.readFile "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml")
      // builtins.fromTOML (builtins.readFile (pkgs.substitute {
        src = "${pkgs.starship}/share/starship/presets/tokyo-night.toml";
        replacements = ["--replace" "" ""];
      }));
  };
}
