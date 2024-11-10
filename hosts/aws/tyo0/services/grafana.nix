{ lib, config, ... }:
{
  services.grafana = {
    enable = true;
    settings = {
      "auth.generic_oauth" = {
        enabled = "true";
        name = "keycloak";
        allow_sign_up = "true";
        client_id = "grafana";
        # client_secret = "YOUR_APP_CLIENT_SECRET";
        scopes = "openid email profile offline_access roles";
        email_attribute_path = "email";
        login_attribute_path = "username";
        name_attribute_path = "full_name";
        auth_url = "https://id.ny4.dev/realms/ny4/protocol/openid-connect/auth";
        token_url = "https://id.ny4.dev/realms/ny4/protocol/openid-connect/token";
        api_url = "https://id.ny4.dev/realms/ny4/protocol/openid-connect/userinfo";
        role_attribute_path = "contains(resource_access.grafana.roles[*], 'grafanaadmin') && 'GrafanaAdmin' || contains(resource_access.grafana.roles[*], 'admin') && 'Admin' || contains(resource_access.grafana.roles[*], 'editor') && 'Editor' || contains(resource_access.grafana.roles[*], 'viewer') && 'Viewer'";
        allow_assign_grafana_admin = true;
        role_attribute_strict = true;
      };
      analytics = {
        reporting_enabled = false;
        feedback_links_enabled = false;
      };
      auth = {
        disable_login_form = true;
      };
      database = {
        type = "postgres";
        name = "grafana";
        user = "grafana";
        host = "/run/postgresql";
      };
      server = {
        protocol = "socket";
        root_url = "https://grafana.ny4.dev/";
      };
    };
  };

  systemd.services."grafana".serviceConfig.EnvironmentFile =
    config.sops.secrets."grafana/environment".path;

  services.caddy.settings.apps.http.servers.srv0.routes = lib.singleton {
    match = lib.singleton { host = [ "grafana.ny4.dev" ]; };
    handle = lib.singleton {
      handler = "reverse_proxy";
      upstreams = [ { dial = "unix/${config.services.grafana.settings.server.socket}"; } ];
    };
  };
}
