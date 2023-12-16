_final: prev: {
  gnome =
    prev.gnome
    // {
      # Restore Nautilus's typeahead ability
      # .patch file from from aur/nautilus-typeahead
      nautilus = prev.gnome.nautilus.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            (prev.fetchgit {
                url = "https://aur.archlinux.org/nautilus-typeahead.git";
                rev = "26776193230b0d56f714d31d79c5e716ac413a26";
                hash = "sha256-hVWZCQwHzL4j+FcgsEhuumhBkl6d8IIbcYddh08QMJM=";
                sparseCheckout = [
                  "nautilus-restore-typeahead.patch"
                ];
              }
              + "/nautilus-restore-typeahead.patch")
          ];
      });
    };
}
