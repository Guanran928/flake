{ config, ... }:

{
  # Installed packages (System wide)
  environment = {
    defaultPackages = [];
  };

  # Programs
  programs = {
    dconf.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true; # default editor, does not seem to set the $EDITOR variable idk
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
    #cron.enable = true;
    #dbus.enable = true;
    openssh.enable = true;
    # BTRFS De-Dupe
    # bruh how to make it not a background job
    # i want to run it manually
    #beesd.filesystems = {
    #  root = {
    #    spec = "UUID=6288ce7a-a153-4302-a4de-5dc71f58da79";
    #    hashTableSizeMB = 2048;
    #    verbosity = "crit";
    #    extraOptions = [ "--loadavg-target" "5.0" ];
    #  };
    #};
  };
}
