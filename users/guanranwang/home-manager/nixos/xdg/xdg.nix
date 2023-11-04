{config, ...}: {
  xdg.enable = true;

  home = {
    sessionVariables = {
      "CUDA_CACHE_PATH" = "${config.xdg.cacheHome}/nv";
      "GNUPGHOME" = "${config.xdg.dataHome}/gnupg";
    };

    shellAliases = {
      "irssi" = "irssi -- config=${config.xdg.configHome}/irssi/config -- home=${config.xdg.dataHome}/irssi";
    };
  };
}
