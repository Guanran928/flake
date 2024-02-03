{lib, ...}: {
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };

  # not sure how to write keybinds in nix (see line 16)
  xdg.configFile."zellij/config.kdl".text = lib.mkForce ''
    theme "tokyo-night-dark"
    simplified_ui true
    pane_frames false
    // default_layout "compact" // still learning the keybinds!

    on_force_close "quit"
    mirror_session false

    keybinds {
      normal {
        bind "Alt 1" { GoToTab 1; }
        bind "Alt 2" { GoToTab 2; }
        bind "Alt 3" { GoToTab 3; }
        bind "Alt 4" { GoToTab 4; }
        bind "Alt 5" { GoToTab 5; }
        bind "Alt 6" { GoToTab 6; }
        bind "Alt 7" { GoToTab 7; }
        bind "Alt 8" { GoToTab 8; }
        bind "Alt 9" { GoToTab 9; }
        bind "Alt 0" { GoToTab 10; }
      }
    }
  '';
}
