{
  environment.etc.machine-id.text = "b08dfa6083e7567a1921a715000001fb"; # whonix id
  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "dccp"
    "netrom"
    "rds"
    "rose"
    "stcp"
    "tipc"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
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
