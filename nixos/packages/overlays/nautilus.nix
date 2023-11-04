{...}: {
  nixpkgs = {
    overlays = [
      (
        final: prev: {
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
                        ### 44.2
                        rev = "dc295b3191818d16550400e645e108d9e265baa3";
                        hash = "sha256-jCZcmPvmEodDzv+HHp7s+azLKVIno1ue72dQO+WbENU=";
                        ### 45.0
                        #rev = "26776193230b0d56f714d31d79c5e716ac413a26";
                        #hash = "sha256-hVWZCQwHzL4j+FcgsEhuumhBkl6d8IIbcYddh08QMJM=";
                        sparseCheckout = [
                          "nautilus-restore-typeahead.patch"
                        ];
                      }
                      + "/nautilus-restore-typeahead.patch")
                  ];
              });
            };
        }
      )
    ];
  };
}
