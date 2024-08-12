{config, ...}: {
  services.vaultwarden = {
    enable = true;
    environmentFile = config.sops.secrets."vaultwarden/environment".path;
    config = {
      DOMAIN = "https://vault.ny4.dev";
      IP_HEADER = "X-Forwarded-For";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 9500;

      EMERGENCY_ACCESS_ALLOWED = false;
      SENDS_ALLOWED = false;
      SIGNUPS_ALLOWED = false;
      ORG_CREATION_USERS = "none";
    };
  };
}
