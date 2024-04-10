{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        "layer" = "top";
        "modules-left" = ["custom/launcher" "sway/workspaces" "gamemode"];
        "modules-center" = ["sway/window"];
        "modules-right" = ["tray" "pulseaudio" "battery" "clock"];
        "custom/launcher" = {"format" = "";};
        "gamemode" = {
          "format" = "{glyph} {count}";
          "glyph" = "󰊴";
          "hide-not-running" = true;
          "use-icon" = true;
          "icon-name" = "input-gaming-symbolic";
          "icon-spacing" = 4;
          "icon-size" = 20;
          "tooltip" = true;
          "tooltip-format" = "Games running = {count}";
        };
        "sway/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "urgent" = "";
            "active" = "";
            "default" = "";
          };
        };
        "sway/window" = {
          "format" = "{}";
          "separate-outputs" = true;
        };
        "tray" = {
          "spacing" = 10;
        };
        "pulseaudio" = {
          "format" = "{volume}% {icon}";
          "format-bluetooth" = "{volume}% {icon}";
          "format-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "󰂑";
            "headset" = "󰂑";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" ""];
          };
          "scroll-step" = 5;
          "on-click" = "pwvucontrol";
          "ignored-sinks" = ["Easy Effects Sink"];
        };
        "battery" = {
          "bat" = "BAT0";
          "interval" = 60;
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-icons" = ["" "" "" "" ""];
          "max-length" = 25;
        };
        "clock" = {
          # https://fmt.dev/latest/syntax.html#chrono-specs
          "format" = "{:%a %b %d %I:%M %p} ";
          "tooltip-format" = "{calendar}";
          "calendar" = {
            "mode" = "month";
            "mode-mon-col" = 3;
            "on-scroll" = -1;
            "format"."today" = "<b><u>{}</u></b>";
          };
          "actions" = {
            "on-click-right" = "mode";
            "on-scroll-up" = "shift_down";
            "on-scroll-down" = "shift_up";
          };
        };
        "cava" = {
          "framerate" = 30;
          "autosens" = 1;
          #"sensitivity" = 1;
          "bars" = 14;
          "method" = "pipewire";
          "bar_delimiter" = 0;
          #"monstercat" = false;
          #"waves" = false;
          "format-icons" = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          "actions"."on-click-right" = "mode";
        };
      };
    };
    style = ''
      * {
        font: bold 14px "JetBrainsMono Nerd Font Propo";
      }
      window#waybar {
        background: transparent;
      }
      tooltip {
        background: #1a1b26;
        color: #c0caf5;
        border: 2px solid #c0caf5;
        border-radius: 5px;
      }
      tooltip label {
        color: #c0caf5;
      }
      #custom-launcher,
      #gamemode,
      #window,
      #workspaces,
      #tray,
      #pulseaudio,
      #battery,
      #clock {
        text-shadow: 1px 1px 2px black;
        background: #1a1b26;
        color: #c0caf5;
        margin: 10px 4px 4px 4px;
        padding: 4px 10px;
        box-shadow: 1px 1px 2px 1px rgba(0, 0, 0, 0.4);
        border-radius: 5px;
      }
      #custom-launcher {
        margin-left: 10px;
      }
      #clock {
        margin-right: 10px;
      }
      #workspaces {
        padding: 0px;
      }
      #workspaces button {
        text-shadow: 1px 1px 2px black;
        color: #c0caf5;
        padding: 0px 4px;
        border: 2px solid #1a1b26;
        transition-property: background, color, text-shadow, min-width;
        transition-duration: .15s;
      }
      #workspaces button.focused {
        text-shadow: none;
        color: #c0caf5;
        background: linear-gradient(
          70deg,
          rgb(192, 202, 245),
          rgb(192, 202, 245),
          rgb(192, 202, 245),
          rgb(192, 202, 245),
          rgb(229, 234, 255),
          rgb(192, 202, 245),
          rgb(192, 202, 245),
          rgb(192, 202, 245),
          rgb(192, 202, 245)
        );
        background-size: 300% 100%;
        background-position: 0% 0%;
        animation: colored-gradient 2s linear infinite;
        color: #1a1b26;
        min-width: 36px;
      }
      #workspaces button.focused:hover {
        background: #9fa7cc;
      }
      #workspaces button:hover {
        background: #11111b;
      }
      @keyframes colored-gradient {
        from {background-position: 0% 0%;}
        to   {background-position: 100% 0%;}
      }
    '';
  };
}
