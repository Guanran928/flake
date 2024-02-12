let
  addPatches = pkg: patches:
    pkg.overrideAttrs (old: {
      patches = (old.patches or []) ++ patches;
    });
in {
  nautilus = {
    typeahead = import ./nautilus/typeahead.nix {inherit addPatches;};
  };
  prismlauncher = {
    offline-mode = import ./prismlauncher/offline-mode.nix {inherit addPatches;};
  };
  sway = {
    input-method-popup = import ./sway/input-method-popup.nix {inherit addPatches;};
    tray-dbus-menu = import ./sway/tray-dbus-menu.nix {inherit addPatches;};
  };
}
