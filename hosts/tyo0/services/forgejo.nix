{ pkgs, ... }:
{
  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    database.type = "postgres";
    settings = {
      server = {
        DOMAIN = "git.ny4.dev";
        PROTOCOL = "http+unix";
        ROOT_URL = "https://git.ny4.dev/";
        SSH_DOMAIN = "tyo0.ny4.dev";
      };

      service = {
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
      };
    };
  };
}
