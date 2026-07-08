{ inputs, pkgs, ... }: {
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  # pkgs.throne on host
  networking.proxy = {
    httpProxy = "http://127.0.0.1:2080";
    httpsProxy = "http://127.0.0.1:2080";
  };

  programs.nix-ld = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # neovim has some issues with my keyboard layout & WSL
  # e.g. I'm not able to type '!'
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    git
    gh
    opencode
    nil
    nixfmt
  ];

  nix.settings = {
    substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    trusted-users = [ "@wheel" ];
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };

  system.stateVersion = "25.11";
}
