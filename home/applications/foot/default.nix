{ config, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main.font = "monospace:size=10";
      main.resize-by-cells = false;
      cursor.style = "beam";
      url.label-letters = "aoeuhtns";

      # tokyonight
      colors = {
        cursor = "283457 c0caf5";
        foreground = "c0caf5";
        background = "1a1b26";
        selection-foreground = "c0caf5";
        selection-background = "283457";
        urls = "73daca";

        regular0 = "15161e";
        regular1 = "f7768e";
        regular2 = "9ece6a";
        regular3 = "e0af68";
        regular4 = "7aa2f7";
        regular5 = "bb9af7";
        regular6 = "7dcfff";
        regular7 = "a9b1d6";

        bright0 = "414868";
        bright1 = "f7768e";
        bright2 = "9ece6a";
        bright3 = "e0af68";
        bright4 = "7aa2f7";
        bright5 = "bb9af7";
        bright6 = "7dcfff";
        bright7 = "c0caf5";

        "16" = "ff9e64";
        "17" = "db4b4b";
      };
    };
  };

  home.sessionVariables."TERMINAL" = config.programs.foot.package;
}
