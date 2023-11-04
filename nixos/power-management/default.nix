{...}: {
  imports = [
    ./cpu-governor.nix
    ./system76-scheduler.nix
    #./tlp.nix                  # ] Conflicts with each other, only choose one
    ./power-profiles-daemon.nix # ]
  ];
}
