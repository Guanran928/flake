{ ... }:

{
  imports = [
    ./boot
    ./i18n
    ./networking
    ./nix
    ./packages
    ./power-management
    ./security
    #./specialisation # dont actually use this
    ./users
  ];
}
