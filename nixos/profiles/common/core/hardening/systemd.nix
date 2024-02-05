# Stolen from https://github.com/CPlusPatch/infra/blob/main/traits/hardening/systemd.nix
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
  };
}
