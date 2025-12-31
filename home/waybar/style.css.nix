let
  c = import ../../lib/colors.nix |> builtins.mapAttrs (_n: v: "#${v}");

  bg = c.neutral-800;
  bg_muted = c.neutral-700;
  fg = c.neutral-300;
in
# css
''
  * {
    font-family: monospace;
    font-size: 12px;
  }

  window#waybar {
    background: transparent;
  }

  #workspaces,
  #clock,
  #battery,
  #backlight,
  #network,
  #wireplumber,
  #tray,
  #idle_inhibitor,
  #power-profiles-daemon,
  #mpris {
    background-color: ${bg};
    padding: 4px 12px;
    margin-top: 8px;
    color: ${fg};
  }

  #tray {
    margin-right: 12px;
  }

  #workspaces {
    margin-left: 12px;
    padding: 0px;
  }

  /* Reset default style */
  #workspaces button {
    padding: 0 5px;
    border-radius: 0;
  }

  #workspaces button.active {
    background-color: ${bg_muted};
  }

  #power-profiles-daemon.performance {
    background-color: ${c.red-950};
  }

  #power-profiles-daemon.balanced {
    background-color: ${c.cyan-950};
  }

  #power-profiles-daemon.power-saver {
    background-color: ${c.green-950};
  }

  #battery.charging,
  #battery.plugged {
    background-color: ${c.green-950};
  }

  #battery.critical:not(.charging) {
    background-color: ${c.red-800};
    animation-name: blink;
    animation-duration: 1s;
    animation-timing-function: ease-in-out;
    animation-iteration-count: infinite;
    animation-direction: alternate;
  }

  @keyframes blink {
    to {
      background-color: ${c.red-700};
    }
  }
''
