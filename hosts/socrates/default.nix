{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  environment.packages = with pkgs; [
    git
    openssh

    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Asia/Shanghai";

  # Set termux font
  # NOTE: Use "Mono" variation, or Termux will cut your icons in half
  terminal.font = "${pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];}}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFontMono-Regular.ttf";

  # Set user shell
  user.shell = lib.getExe pkgs.fish;
  environment.sessionVariables."SHELL" = lib.getExe pkgs.fish;

  # Set up HM
  home-manager = {
    backupFileExtension = "hmbak";
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      osConfig = config;
    };
    config = ../../home;
    sharedModules = [
      ({...}: {
        imports = [
          ../../home/applications/neovim
          ../../home/applications/nix
        ];
      })
    ];
  };
}
