{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird.override {
      extraPolicies = {
        DisableTelemetry = true;
        Preferences = {
          mailnews.start_page.enabled = true;
          mail.identity.default.compose_html = false;
        };
      };
    };
    profiles.default = {
      isDefault = true;
    };
  };
}
