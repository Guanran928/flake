{ pkgs, ... }:
{
  home.packages = [ pkgs.tmux ];

  xdg.configFile."tmux/tmux.conf".text =
    # tmux
    ''
      run-shell ${pkgs.tmuxPlugins.sensible.rtp}

      set-option    -s default-terminal  "tmux-256color"

      set-option    -g base-index        1
      set-option -w -g pane-base-index   1
      set-option    -g renumber-windows  on

      set-option    -g status-keys        vi
      set-option -w -g mode-keys          vi
      set-option    -g mouse              on
      set-option    -s set-clipboard      on
      set-option -w -g aggressive-resize  on
      set-option    -g destroy-unattached keep-last

      set-option    -g status-style "bg=black"
      set-option    -g status-left  ""
      set-option    -g status-right " #S "
      set-option    -g status-right-style "fg=black bg=blue"
      set-option -w -g window-status-separator ""
      set-option -w -g window-status-format " #I #W #F "
      set-option -w -g window-status-current-format " #I #W #F "
      set-option -w -g window-status-current-style "fg=black bg=blue"
      set-option -w -g window-status-bell-style "fg=black bg=yellow bold"

      bind-key    -N "Select pane to the left of the active pane"  h select-pane -L
      bind-key    -N "Select pane below the active pane"           j select-pane -D
      bind-key    -N "Select pane above the active pane"           k select-pane -U
      bind-key    -N "Select pane to the right of the active pane" l select-pane -R
      bind-key -r -N "Resize the pane left by 5"                   H resize-pane -L 5
      bind-key -r -N "Resize the pane down by 5"                   J resize-pane -D 5
      bind-key -r -N "Resize the pane up by 5"                     K resize-pane -U 5
      bind-key -r -N "Resize the pane right by 5"                  L resize-pane -R 5
    '';
}
