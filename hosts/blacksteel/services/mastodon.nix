{config, ...}: {
  services.mastodon = {
    enable = true;
    localDomain = "ny4.dev";
    streamingProcesses = 1;
    mediaAutoRemove.olderThanDays = 14;
    # FIXME: this doesn't exist
    smtp = {
      createLocally = false;
      fromAddress = "mastodon@ny4.dev";
    };
    extraConfig = rec {
      SINGLE_USER_MODE = "true";
      WEB_DOMAIN = "mastodon.ny4.dev";

      # keycloak
      OMNIAUTH_ONLY = "true";
      OIDC_ENABLED = "true";
      OIDC_CLIENT_ID = "mastodon";
      # OIDC_CLIENT_SECRET # EnvironmentFile
      OIDC_DISCOVERY = "true";
      OIDC_DISPLAY_NAME = "id.ny4.dev";
      OIDC_ISSUER = "https://id.ny4.dev/realms/ny4";
      OIDC_REDIRECT_URI = "https://${WEB_DOMAIN}/auth/auth/openid_connect/callback";
      OIDC_SCOPE = "openid,profile,email";
      OIDC_SECURITY_ASSUME_EMAIL_IS_VERIFIED = "true";
      OIDC_UID_FIELD = "preferred_username";
    };
  };

  systemd.services.mastodon-web = {
    environment = config.networking.proxy.envVars;
    serviceConfig.EnvironmentFile = [config.sops.secrets."mastodon/environment".path];
  };

  systemd.services.mastodon-sidekiq-all.environment = config.networking.proxy.envVars;
}
