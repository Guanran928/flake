{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  ### Options
  home-manager.users.guanranwang = import ./home;

  imports = [
    ./nix
    ./anti-features.nix
    ./networking.nix

    inputs.self.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    inputs.nur.nixosModules.nur # doesn't sound very smart
  ];

  users = {
    knownUsers = ["guanranwang"];
    users."guanranwang" = {
      createHome = true;
      description = "Guanran Wang";
      home = "/Users/guanranwang";
      shell = pkgs.fish;
      uid = 501;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;}; # ??? isnt specialArgs imported by default ???
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  # WORKAROUND: Fix $PATH orders when using Fish shell
  # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
  programs.fish.loginShellInit = let
    # Double quotes instead of single quotes are necessary
    # ["$HOME/.local" "/usr/local"] -> "\"$HOME/.local/bin' '/usr/local/bin\""
    makePath = path: lib.concatMapStringsSep " " (path: "\"${path}/bin\"") path;
  in ''
    fish_add_path --move --prepend --path ${makePath config.environment.profiles}
    set fish_user_paths $fish_user_paths
  '';

  # Install more recent versions of some macOS tools.
  # https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh
  environment.systemPackages = with pkgs; [
    bashInteractive
    coreutils
    findutils
    git
    gnugrep
    gnused
    openssh
    screen
    tree
    vim
  ];
}
