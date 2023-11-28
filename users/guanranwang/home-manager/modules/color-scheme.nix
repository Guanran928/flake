{lib, ...}: {
  options.myFlake.home-manager = {
    colorScheme = lib.mkOption {
      type = lib.types.enum [null "tokyonight"];
      default = "tokyonight";
      description = "Select desired terminal color scheme.";
    };
  };
}
