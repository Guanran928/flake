{ pkgs, ... }:

{
  users.users."guanranwang" = {
    isNormalUser = true;
    description = "Guanran Wang";
    extraGroups = [ "wheel" "networkmanager" "tss" ]; # tss = access to tpm devices
    #passwordFile = config.sops.secrets."user-password-guanranwang".path;
    hashedPassword = "$y$j9T$D7kBBBGwxw1XmPApAHIsx/$hcB64v3/kvPB7nIM9wXFiaSSBfhSp9k/JQ4R9G3guk6";
    shell = pkgs.fish;
    packages = [];
  };
}