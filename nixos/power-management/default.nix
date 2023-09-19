{ ... }:

{
  imports = [
    ./cpu-governor.nix
    ./system76-scheduler.nix
    #./tlp.nix                  # ] conflicts
    ./power-profiles-daemon.nix # ]
  ];
}