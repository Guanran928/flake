{
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.blackbox-terminal];

  # classic... dconf
  dconf.settings."com/raggesilver/BlackBox" = {
    pretty = false; # "Theme Integration"
    cursor-shape = lib.hm.gvariant.mkUint32 1; # "line" cursor
    #show-headerbar = false;
    terminal-padding = lib.hm.gvariant.mkTuple [
      (lib.hm.gvariant.mkUint32 12)
      (lib.hm.gvariant.mkUint32 12)
      (lib.hm.gvariant.mkUint32 12)
      (lib.hm.gvariant.mkUint32 12)
    ];
  };

  # TODO: Tokyo Night
  # Example:
  #''
  #  {
  #    "name": "Gruvbox for Tilix",
  #    "comment": "Ported for Trilix Colour Scheme",
  #    "use-theme-colors": false,
  #    "foreground-color": "#ebdbb2",
  #    "background-color": "#282828",
  #    "palette": [
  #       "#282829",
  #       "#cc241d",
  #       "#98971a",
  #       "#d79921",
  #       "#458588",
  #       "#b16286",
  #       "#689d6a",
  #       "#a89984",
  #       "#928374",
  #       "#fb4934",
  #       "#b8bb26",
  #       "#fabd2f",
  #       "#83a598",
  #       "#d3869b",
  #       "#8ec07c",
  #       "#ebdbb2"
  #    ]
  #  }
  #'';
}
