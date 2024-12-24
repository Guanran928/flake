{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  home = {
    username = "guanranwang";
    homeDirectory = "/home/guanranwang";
    stateVersion = "24.05";
  };

  imports = [
    ./theme.nix
    ./xdg-mime.nix
  ] ++ lib.filter (x: lib.hasSuffix "default.nix" x) (lib.fileset.toList ./applications);

  programs = {
    jq.enable = true;
    man.generateCaches = false;
    mangohud.enable = true;
    obs-studio.enable = true;
    ripgrep.enable = true;
    skim.enable = true;
    zoxide.enable = true;
  };

  services = {
    cliphist.enable = true;
    udiskie.enable = true;
  };

  home.packages =
    (with pkgs; [
      dconf-editor
      fastfetch
      fd
      file-roller
      gnome-calculator
      hyperfine
      libnotify
      loupe
      pwvucontrol
      seahorse
      telegram-desktop
      wl-clipboard

      lunar-client
      (osu-lazer-bin.override { nativeWayland = true; })
      (prismlauncher.override { jdks = [ pkgs.jdk21 ]; })
    ])
    ++ (with inputs.self.legacyPackages.${pkgs.stdenv.hostPlatform.system}; [ mumble-git ]);
}
