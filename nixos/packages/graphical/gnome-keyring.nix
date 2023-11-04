{pkgs, ...}: {
  # gnome keyring
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  security.pam.services."gnome-keyring".text = ''
    auth     optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
    session  optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
    password optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
  '';
}
