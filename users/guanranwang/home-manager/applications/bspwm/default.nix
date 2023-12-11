{pkgs, ...}: {
  imports = [
    ../dunst
    ../picom
    ../polybar
    ../rofi
    ../sxhkd
    ../udiskie
  ];

  home.packages = with pkgs; [flameshot feh];

  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      startupPrograms = [
        "pgrep -x sxhkd > /dev/null || sxhkd"
        "pgrep -x feh > /dev/null || feh --bg-fill ~/.local/share/backgrounds/aqua.png"
      ];
      monitors = {
        eDP-1 = ["I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X"];
      };
      settings = {
        border_width = 2;
        window_gap = 4;
        focus_follows_pointer = true;
        split_ratio = 0.52;
        borderless_monocle = true;
        gapless_monocle = true;
      };
    };
  };

  home.file.".xinitrc".text = ''
    #!/bin/sh

    userresources=$HOME/.Xresources
    usermodmap=$HOME/.Xmodmap
    sysresources=/etc/X11/xinit/.Xresources
    sysmodmap=/etc/X11/xinit/.Xmodmap

    # merge in defaults and keymaps
    if [ -f $sysresources ]; then
        xrdb -merge $sysresources
    fi

    if [ -f $sysmodmap ]; then
        xmodmap $sysmodmap
    fi

    if [ -f "$userresources" ]; then
        xrdb -merge "$userresources"

    fi

    if [ -f "$usermodmap" ]; then
        xmodmap "$usermodmap"
    fi

    # start some nice programs
    if [ -d /etc/X11/xinit/xinitrc.d ] ; then
     for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
      [ -x "$f" ] && . "$f"
     done
     unset f
    fi

    exec bspwm
  '';
}
