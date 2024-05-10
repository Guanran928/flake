{lib, ...}: {
  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
  xdg.mimeApps = {
    enable = true;

    # Default application associstions
    defaultApplications =
      {
        "inode/directory" = ["org.gnome.Nautilus.desktop"];
      }
      ### Browser
      // lib.genAttrs [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ] (_n: ["librewolf.desktop" "firefox.desktop" "chromium-browser.desktop"])
      ### Audio player
      // lib.genAttrs [
        "audio/aac"
        "audio/flac"
        "audio/mpeg"
        "audio/ogg"
        "audio/wav"
      ] (_n: ["io.bassi.Amberol.desktop" "mpv.desktop"])
      ### Image viewer
      // lib.genAttrs [
        "image/gif"
        "image/jpeg"
        "image/png"
        "image/webp"
      ] (_n: ["org.gnome.Loupe.desktop"])
      ### Video player
      // lib.genAttrs [
        "video/mp4"
        "video/mpeg"
        "video/webm"
      ] (_n: ["mpv.desktop"])
      ### Code editor
      // lib.genAttrs [
        "text/css"
        "text/html"
        "text/javascript"
        "text/plain"
      ] (_n: ["codium.desktop" "Helix.desktop" "nvim.desktop"]);
  };
}
