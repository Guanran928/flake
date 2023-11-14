{...}: {
  imports = [
    ./flameshot.nix
    ./rofi.nix
    ../../terms/alacritty.nix
  ];

  services.sxhkd = {
    enable = true;
    keybindings = {
      #
      # wm independent hotkeys
      #
      "super + Return" = "alacritty"; # terminal emulator
      "super + e" = "xdg-open ~"; # file manager
      "super + w" = "xdg-open http://"; # browser
      "super + d" = "rofi -show drun -show-icons -icon-theme Tela-dracula-dark"; # program launcher
      "super + shift + s" = "flameshot gui"; # flameshot
      "super + BackSpace" = "betterlockscreen -l";

      #
      # bspwm hotkeys
      #
      "super + shift + r" = "bspc wm -r;pkill -USR1 -x sxhkd"; # reload bspwm
      "control + alt + Delete" = "bspc quit"; # quit bspwm
      "super + q" = "bspc node -c"; # close window
      "super + m" = "bspc desktop -l next"; # wtf is this; # alternate between the tiled and monocle layout
      "super + y" = "bspc node newest.marked.local -n newest.!automatic.local"; # wtf is this; # send the newest marked node to the newest preselected node
      "super + g" = "bspc node -s biggest.window"; # wtf is this; # swap the current node and the biggest window

      #
      # state/flags
      #
      "super + {a,shift + a,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}"; # set the window state
      "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}"; # huh; # set the node flags

      #
      # focus/swap
      #
      "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}"; # focus the node in the given direction
      "super + {p,b,comma,period}" = "bspc node -f @{parent,brother,first,second}"; # focus the node for the given path jump
      "super + {_,shift + }c" = "bspc node -f {next,prev}.local.!hidden.window"; # focus the next/previous window in the current desktop
      "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local"; # focus the next/previous desktop in the current monitor
      "super + {grave,Tab}" = "bspc {node,desktop} -f last"; # focus the last node/desktop
      "super + {o,i}" = "bspc wm -h off; bspc node {older,newer} -f; bspc wm -h on"; # focus the older or newer node in the focus history
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'"; # focus or send to the given desktop

      #
      # preselect
      #
      "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}"; # preselect the direction
      "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}"; # preselect the ratio
      "super + ctrl + space" = "bspc node -p cancel"; # cancel the preselection for the focused node
      "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel"; # cancel the preselection for the focused desktop

      #
      # move/resize
      #
      "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}"; # expand a window by moving one of its side outward
      "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}"; # contract a window by moving one of its side inward
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}"; # move a floating window

      #
      # fn keys
      #
      ### brightness keys
      "XF86MonBrightnessUp" = "/home/guanranwang/.local/bin/wrapped-brightnessctl up";
      "XF86MonBrightnessDown" = "/home/guanranwang/.local/bin/wrapped-brightnessctl down";

      ### media keys
      "XF86AudioPrev" = "playerctl previous";
      "XF86AudioNext" = "playerctl next";
      "XF86AudioPlay" = "playerctl play-pause";

      ### volume keys
      "XF86AudioRaiseVolume" = "/home/guanranwang/.local/bin/wrapped-pamixer up";
      "XF86AudioLowerVolume" = "/home/guanranwang/.local/bin/wrapped-pamixer down";
      "XF86AudioMute" = "/home/guanranwang/.local/bin/wrapped-pamixer mute";
    };
  };
}
