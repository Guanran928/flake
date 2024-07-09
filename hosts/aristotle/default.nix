{pkgs, ...}: {
  imports = [
    ../../nixos/profiles/opt-in/mihomo
    ../../nixos/profiles/opt-in/wireless

    ./anti-feature.nix
    ./disko.nix
    ./graphical
    ./hardware-configuration.nix
    ./impermanence.nix
    ./lanzaboote.nix
  ];

  networking.hostName = "aristotle";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "23.11";

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  programs.adb.enable = true;
  programs.anime-game-launcher.enable = true;
  programs.steam.enable = true;
  services.power-profiles-daemon.enable = true;

  # https://wiki.archlinux.org/title/Gamepad#Connect_Xbox_Wireless_Controller_with_Bluetooth
  hardware.xone.enable = true; # via wired or wireless dongle
  hardware.xpadneo.enable = true; # via Bluetooth

  ### https://wiki.archlinux.org/title/Gaming#Improving_performance
  systemd.tmpfiles.rules = [
    "w /proc/sys/vm/min_free_kbytes - - - - 1048576"
    "w /proc/sys/vm/swappiness - - - - 10"
    "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
    "w /proc/sys/vm/zone_reclaim_mode - - - - 0"
    "w /proc/sys/vm/page_lock_unfairness - - - - 1"
    "w /proc/sys/kernel/sched_child_runs_first - - - - 0"
    "w /proc/sys/kernel/sched_autogroup_enabled - - - - 1"
    "w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 500"
    "w /sys/kernel/debug/sched/latency_ns  - - - - 1000000"
    "w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000"
    "w /sys/kernel/debug/sched/min_granularity_ns - - - - 500000"
    "w /sys/kernel/debug/sched/wakeup_granularity_ns  - - - - 0"
    "w /sys/kernel/debug/sched/nr_migrate - - - - 8"
  ];

  # yubikey
  environment.systemPackages = [pkgs.yubikey-manager];
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];
}
