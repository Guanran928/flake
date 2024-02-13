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
in [librewolf]
