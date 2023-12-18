{pkgs, ...}: {
  home.packages = with pkgs; [
    pavucontrol
  ];

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      "button-layout" = "icon,appmenu:"; # remove csd window buttons
    };
  };
}
