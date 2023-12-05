{
  config,
  lib,
  ...
}: {
  # Imported by default
  imports = [
    ../../modules

    ./nix
    ./packages
    ./sysctl.nix
  ];

  boot.initrd.systemd.enable = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = lib.mkDefault true; # mkDefault for Lanzaboote
      editor = false; # Disabled for security
      ### Utilities
      #netbootxyz.enable = true;
      #memtest86.enable = true;
    };
  };

  users.mutableUsers = false;

  # Programs
  environment.defaultPackages = [];
  programs = {
    dconf.enable = true;
    nano.enable = false; # make sure to add another editor and set the $EDITOR variable, in this case I am using neovim
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };

  # Services
  services = {
    getty.greetingLine = let
      inherit (config.system) nixos;
      inherit (config.myFlake.nixos.hardware.components) gpu;
    in ''
      NixOS ${nixos.label} ${nixos.codeName} (\m) - \l
      ${lib.strings.optionalString gpu.nvidia.enable
        "--my-next-gpu-wont-be-nvidia"}
      ${lib.strings.optionalString gpu.amd.enable
        "[    5.996722] amdgpu 0000:67:00.0: Fatal error during GPU init"}
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

  ### Basic hardening
  # ref: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
  # ref: https://madaidans-insecurities.github.io/guides/linux-hardening.html
  #
  # also see: ./sysctl.nix

  environment.etc.machine-id.text = "b08dfa6083e7567a1921a715000001fb"; # whonix id
  security = {
    apparmor.enable = true;
    sudo.execWheelOnly = true;
  };

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];
}
