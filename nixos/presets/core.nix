{config, ...}:
# Imported by default, check out ./desktop.nix or ./server.nix
{
  imports = [
    ../boot
    ../networking
    ../nix
    ../packages
    ../power-management
    #../specialisation # dont actually use this
  ];

  # Installed packages (System wide)
  environment.defaultPackages = []; # make sure to add another editor and set the $EDITOR variable, in this case I am using neovim

  users.mutableUsers = false;
  environment.etc.machine-id.text = "b08dfa6083e7567a1921a715000001fb"; # whonix id
  security = {
    apparmor.enable = true;
    sudo.execWheelOnly = true;
  };

  # Programs
  programs = {
    dconf.enable = true;
    nano.enable = false;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
    fish.enable = true;
    #zsh.enable = true;
  };

  # Services
  services = {
    getty.greetingLine = ''
      NixOS ${config.system.nixos.label} ${config.system.nixos.codeName} (\m) - \l
      --my-next-gpu-wont-be-nvidia
    '';

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    #cron.enable = true;
    #dbus.enable = true;

    # BTRFS De-Dupe
    # bruh how to make it not a background job
    # i want to run it manually
    #beesd.filesystems = {
    #  root = {
    #    spec = "UUID=3e10ff73-e1f7-4b39-88f5-7f31dcc8f38c";
    #    hashTableSizeMB = 2048;
    #    verbosity = "crit";
    #    #extraOptions = [ "--loadavg-target" "5.0" ];
    #  };
    #};
  };
}
