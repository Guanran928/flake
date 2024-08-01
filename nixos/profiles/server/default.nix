{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty.terminfo
    kitty.terminfo
    foot.terminfo
    tmux.terminfo
    wezterm.terminfo
  ];

  # TODO: colmena
  services.openssh.settings.PermitRootLogin = "prohibit-password";
}
