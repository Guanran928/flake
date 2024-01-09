{
  inputs,
  pkgs,
  ...
}: let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  librewolf = mkNixPak {
    config = {
      config,
      sloth,
      ...
    }: {
      app.package = pkgs.librewolf;
      flatpak.appId = "io.gitlab.librewolf-community";

      imports = [
        (inputs.nixpak-pkgs + "/pkgs/modules/gui-base.nix")
        (inputs.nixpak-pkgs + "/pkgs/modules/network.nix")
      ];

      # Specified in https://github.com/schizofox/schizofox/blob/main/modules/hm/default.nix
      # I really don't have any idea what am I doing, it just works™
      dbus.policies = {
        "io.gitlab.librewolf.*" = "own";
      };

      bubblewrap = let
        envSuffix = envKey: sloth.concat' (sloth.env envKey);
      in {
        bind.rw = [
          "/tmp/.X11-unix"
          (sloth.envOr "XAUTHORITY" "/no-xauth")
          (envSuffix "XDG_RUNTIME_DIR" "/dconf")
          (sloth.concat' sloth.homeDir "/.librewolf")
          (sloth.concat' sloth.homeDir "/Downloads")
        ];
        bind.ro = [
          "/etc/localtime"
          "/sys/bus/pci"

          ["${config.app.package}/lib/librewolf" "/app/etc/librewolf"]
          (sloth.concat' sloth.xdgConfigHome "/dconf")
        ];
      };
    };
  };
in {
  programs.librewolf = {
    enable = true;
    package = librewolf.config.env;
    settings = {
      # https://codeberg.org/librewolf/settings/src/branch/master/librewolf.cfg
      # https://github.com/yokoffing/Betterfox/blob/main/librewolf.overrides.cfg

      ### Restore disabled functions
      "browser.cache.disk.enable" = true;
      "identity.fxaccounts.enabled" = true;
      "media.eme.enabled" = true;
      "privacy.donottrackheader.enabled" = false;
      "privacy.globalprivacycontrol.enabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.sanitize.sanitizeOnShutdown" = false;
      "security.OCSP.enabled" = 0;
      "security.OCSP.require" = false;
      "security.pki.crlite_mode" = 2;
      "webgl.disabled" = false;

      ### Smooth scrolling
      "apz.overscroll.enabled" = true;
      "general.smoothScroll" = true;
      "general.smoothScroll.msdPhysics.enabled" = true;
      "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
      "mousewheel.default.delta_multiplier_y" = 75;

      ### Misc
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    };
  };
}
