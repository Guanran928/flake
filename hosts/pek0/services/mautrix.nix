{
  pkgs,
  config,
  ports,
  ...
}:
{
  services.mautrix-telegram = {
    enable = true;
    environmentFile = config.sops.secrets."mautrix-telegram/environment".path;
    registerToSynapse = false;

    package = pkgs.mautrix-telegram.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        (pkgs.fetchpatch2 {
          url = "https://github.com/mautrix/telegram/commit/0c2764e3194fb4b029598c575945060019bad236.patch";
          hash = "sha256-48QiKByX/XKDoaLPTbsi4rrlu9GwZM26/GoJ12RA2qE=";
        })
      ];
    });

    settings = {
      homeserver = {
        address = "http://127.0.0.1:${toString ports.matrix-synapse}";
        domain = config.services.matrix-synapse.settings.server_name;
      };

      appservice = {
        address = "http://127.0.0.1:${toString ports.mautrix-telegram}";
        database = "postgres:///mautrix-telegram?host=/run/postgresql";
        hostname = "127.0.0.1";
        port = ports.mautrix-telegram;
        provisioning.enabled = false;
      };

      bridge = {
        public_portals = true;
        delivery_error_reports = true;
        incoming_bridge_error_reports = true;
        bridge_matrix_leave = false;
        relay_user_distinguishers = [ ];
        create_group_on_invite = false;
        animated_sticker = {
          target = "webp";
          convert_from_webm = true;
        };
        state_event_formats = {
          join = "";
          leave = "";
          name_change = "";
        };
        permissions = {
          "@nyancat:ny4.dev" = "admin";
        };
        relaybot = {
          authless_portals = false;
        };
      };

      telegram = {
        api_id = 611335;
        api_hash = "d524b414d21f4d37f08684c1df41ac9c";

        proxy = {
          type = "http";
          address = "127.0.0.1";
          port = 1080;
        };
      };
    };
  };

  sops.secrets."mautrix-telegram/environment".restartUnits = [ "mautrix-telegram.service" ];
}
