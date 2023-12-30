{
  pkgs,
  lib,
  config,
  ...
}: {
  myFlake.hardware.accessories.xboxOneController.enable = lib.mkDefault true;

  programs.gamemode = {
    enable = true;
    settings.custom = {
      start = "${lib.getExe pkgs.libnotify} 'GameMode Activated' 'GameMode Activated! Enjoy enhanced performance. 🚀'";
      end = "${lib.getExe pkgs.libnotify} 'GameMode Deactivated' 'GameMode Deactivated. Back to normal mode. ⏹️'";
    };
  };

  # Integrate with NVIDIA Optimus offloading.
  # https://github.com/FeralInteractive/gamemode#note-for-hybrid-gpu-users
  # https://github.com/NixOS/nixpkgs/pull/273177
  environment.sessionVariables = {
    "GAMEMODERUNEXEC" = let
      inherit (config.hardware.nvidia.prime) offload;
    in
      lib.mkIf
      (builtins.elem "nvidia" config.services.xserver.videoDrivers || offload.enable || offload.enableOffloadCmd)
      (lib.mkDefault "nvidia-offload");
  };

  ### https://wiki.archlinux.org/title/Gaming#Improving_performance
  systemd.tmpfiles.rules = [
    #    Path                  Mode UID  GID  Age Argument
    #"w /proc/sys/vm/compaction_proactiveness - - - - 0"
    "w /proc/sys/vm/min_free_kbytes - - - - 1048576"
    "w /proc/sys/vm/swappiness - - - - 10"
    "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
    "w /proc/sys/vm/zone_reclaim_mode - - - - 0"
    #"w /sys/kernel/mm/transparent_hugepage/enabled - - - - never"
    #"w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - never"
    #"w /sys/kernel/mm/transparent_hugepage/khugepaged/defrag - - - - 0"
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
}
