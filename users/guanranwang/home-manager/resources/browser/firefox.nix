{
  inputs,
  pkgs,
  ...
}: let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  firefox = mkNixPak {
    config = {
      config,
      sloth,
      ...
    }: {
      app.package = pkgs.firefox;
      flatpak.appId = "org.mozilla.firefox";

      imports = [
        (inputs.nixpak-pkgs + "/pkgs/modules/gui-base.nix")
        (inputs.nixpak-pkgs + "/pkgs/modules/network.nix")
      ];

      # Specified in https://github.com/schizofox/schizofox/blob/main/modules/hm/default.nix
      # I really don't have any idea what am I doing, it just works™
      bubblewrap = let
        envSuffix = envKey: sloth.concat' (sloth.env envKey);
      in {
        bind.rw = [
          "/tmp/.X11-unix"
          (sloth.envOr "XAUTHORITY" "/no-xauth")
          (envSuffix "XDG_RUNTIME_DIR" "/dconf")
          (sloth.concat' sloth.homeDir "/.mozilla")
          (sloth.concat' sloth.homeDir "/Downloads")
        ];
        bind.ro = [
          "/etc/localtime"
          "/sys/bus/pci"

          ["${pkgs.firefox}/lib/firefox" "/app/etc/firefox"]
          (sloth.concat' sloth.xdgConfigHome "/dconf")

          # https://github.com/nixpak/pkgs/pull/22
          (sloth.concat' sloth.xdgConfigHome "/fontconfig")
        ];
      };
    };
  };
in {
  home.packages = [firefox.config.env];

  # TODO: does not seem to work
  #programs.firefox = {
  #  enable = true;
  #  package = firefox.config.env;
  #
  #  # TODO
  #  profiles."default" = {};
  #};
}
