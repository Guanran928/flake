{
  pkgs,
  inputs,
  ...
}: {
  imports =
    [
      ./theme.nix
      ./xdg-mime.nix
    ]
    ++ map (n: ../../../home/applications/${n}) [
      "fcitx5"
      "firefox"
      "foot"
      "go"
      "mpv"
      "nautilus"
      "nix"
      "sway"
      "thunderbird"
      "ydict"
    ];

  # https://wiki.archlinux.org/title/Fish#Start_X_at_login
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
      exec sway
    end
  '';

  home.packages =
    (with pkgs; [
      amberol
      dconf-editor
      file-roller
      fractal
      gnome-calculator
      hyperfine
      loupe
      mousai
      seahorse

      (prismlauncher.override {
        glfw = glfw-wayland-minecraft;
        gamemodeSupport = false;
      })
      mumble
      osu-lazer-bin
    ])
    ++ (with inputs.self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.scripts; [
      lofi
    ]);

  home.sessionVariables = {
    # https://github.com/ppy/osu-framework/pull/6292
    "OSU_SDL3" = "1";
  };

  programs.mangohud.enable = true;
  programs.obs-studio.enable = true;
  services.ssh-agent.enable = true;
}
