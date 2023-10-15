{ ... }:

{
  imports = [
    ./boot
    ./i18n
    ./networking
    ./nix
    ./packages
    ./power-management
    #./specialisation # dont actually use this
    ./users
  ];
}
