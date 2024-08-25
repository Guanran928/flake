{ pkgs, ... }:
{
  # TODO: https://github.com/NixOS/nixpkgs/pull/287923
  # currently running qbittorrent-nox with tmux :c
  environment.systemPackages = with pkgs; [
    qbittorrent-nox
  ];
}
