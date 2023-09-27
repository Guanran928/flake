{ ... }:

{
  # Default application associstions, ro.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "audio/mpeg" = "io.bassi.Amberol.desktop";
      "audio/flac" = "io.bassi.Amberol.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "image/png" = "org.gnome.eog.desktop";
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
      #"text/html" = "io.gitlab.librewolf-community.desktop";
      #"x-scheme-handler/http" = "io.gitlab.librewolf-community.desktop";
      #"x-scheme-handler/https" = "io.gitlab.librewolf-community.desktop";
      #"x-scheme-handler/about" = "io.gitlab.librewolf-community.desktop";
      #"x-scheme-handler/unknown" = "io.gitlab.librewolf-community.desktop";
      #"text/html" = "org.mozilla.firefox.desktop";
      #"x-scheme-handler/http" = "org.mozilla.firefox.desktop";
      #"x-scheme-handler/https" = "org.mozilla.firefox.desktop";
      #"x-scheme-handler/about" = "org.mozilla.firefox.desktop";
      #"x-scheme-handler/unknown" = "org.mozilla.firefox.desktop";
    };
  };
}
