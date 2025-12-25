{ lib, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        horizontal-pad = 10;
        image-size-ratio = 0;
      };

      border = {
        radius = 0;
      };

      colors =
        let
          c = import ../lib/colors.nix |> lib.mapAttrs (_n: v: "#${v}ff"); # expects #RRGGBBAA

          bg = c.neutral-900;
          bg_highlight = c.neutral-800;

          fg = c.neutral-300;
          fg_muted = c.neutral-500;

          accent = c.blue-400;
          border = c.neutral-800;
        in
        {
          background = bg;
          text = fg;
          prompt = fg_muted;
          placeholder = fg_muted;
          input = fg;
          match = accent;
          selection = bg_highlight;
          selection-text = fg;
          selection-match = accent;
          border = border;
        };
    };
  };
}
