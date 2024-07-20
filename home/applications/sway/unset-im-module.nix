{lib, ...}: {
  options.home.sessionVariables = lib.mkOption {
    apply = x: removeAttrs x ["QT_IM_MODULE" "GTK_IM_MODULE"];
  };
}
