{pkgs, ...}: {
  home.packages = with pkgs; [
    pavucontrol
  ];

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      "button-layout" = "icon,appmenu:"; # remove csd window buttons
    };
  };

  home.sessionVariables = {
    # https://github.com/localsend/localsend/blob/2457acd8a7412723b174672d174e4853dccd7d99/app/linux/my_application.cc#L45
    GTK_CSD = 0;
  };
}
