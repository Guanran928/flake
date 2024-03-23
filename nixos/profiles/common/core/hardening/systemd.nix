# https://github.com/CPlusPatch/infra/blob/fe96d6cc9a71c81fc5326cd1b1115ed8ae8f0073/traits/hardening/systemd.nix
# https://github.com/accelbread/config-flake/blob/d69a8b2d636b322fa1e8ba853bfbf23f9a858e38/nix/nixosModules/tailscale.nix
{
  systemd.services = {
    NetworkManager.serviceConfig = {
      RestrictAddressFamilies = "AF_INET AF_INET6 AF_NETLINK AF_PACKET AF_UNIX";
      ProtectHome = true;
      ProtectSystem = "strict";
      ProtectProc = "invisible";
      ReadWritePaths = "/etc -/proc/sys/net -/var/lib/NetworkManager/";
      PrivateTmp = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      CapabilityBoundingSet = "~CAP_SYS_ADMIN CAP_SETUID CAP_SETGID CAP_SYS_CHROOT";
      NoNewPrivileges = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallFilter = "@system-service @privileged";
      SystemCallArchitectures = "native";
    };

    bluetooth.serviceConfig = {
      RestrictAddressFamilies = "AF_UNIX AF_BLUETOOTH";
      IPAddressDeny = "any";
      ProtectSystem = "strict";
      ReadWritePaths = "-/var/lib/bluetooth -/run/systemd/unit-root";
      PrivateTmp = true;
      ProtectProc = "ptraceable";
      ProcSubset = "pid";
      DevicePolicy = "closed";
      DeviceAllow = ["/dev/rfkill rw" "/dev/uinput rw"];
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      NoNewPrivileges = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallFilter = ["@system-service" "~@resources @privileged"];
      SystemCallArchitectures = "native";
    };

    cups.serviceConfig = {
      RestrictAddressFamilies = "AF_INET AF_INET6 AF_NETLINK AF_UNIX";
      IPAddressDeny = "any";
      IPAddressAllow = ["localhost" "192.168.1.0/8" "172.16.1.0/8" "10.0.1.0/8"];
      ProtectHome = true;
      ProtectSystem = "strict";
      ReadWritePaths = "/etc/cups /etc/printcap /var/cache/cups /var/spool/cups";
      LogsDirectory = "cups";
      RuntimeDirectory = "cups";
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      CapabilityBoundingSet = "CAP_CHOWN CAP_AUDIT_WRITE CAP_DAC_OVERRIDE CAP_FSETID CAP_KILL CAP_NET_BIND_SERVICE CAP_SETGID CAP_SETUID";
      ProtectHostname = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallFilter = "@system-service";
      SystemCallArchitectures = "native";
    };

    systemd-networkd.serviceConfig = {
      After = "apparmor.service systemd-udevd.service network-pre.target systemd-sysusers.service systemd-sysctl.service";
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    auditd.serviceConfig = {
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    NetworkManager-dispatcher.serviceConfig = {
      ProtectHome = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    emergency.serviceConfig = {
      ProtectHome = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = "~@clock @cpu-emulation @obsolete @module @raw-io @swap";
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    logrotate.serviceConfig = {
      ProtectHome = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    power-profiles-daemon.serviceConfig = {
      ProtectHome = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @swap";
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    ncsd.serviceConfig = {
      ProtectHome = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    reload-systemd-vconsole-setup.serviceConfig = {
      ProtectHome = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    rescue.serviceConfig = {
      ProtectHome = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    tailscaled.environment.TS_DEBUG_FIREWALL_MODE = "nftables"; # iptables requires root
    tailscaled.serviceConfig = {
      AmbientCapabilities = ["CAP_NET_RAW" "CAP_NET_ADMIN"];
      CapabilityBoundingSet = ["CAP_NET_RAW" "CAP_NET_ADMIN"];
      DeviceAllow = "/dev/net/tun rw";
      DevicePolicy = "closed";
      DynamicUser = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateIPC = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK"];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = ["@system-service" "~@privileged"];
      UMask = 077;
    };
  };
}
