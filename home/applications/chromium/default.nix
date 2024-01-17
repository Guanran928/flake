{
  programs.chromium = {
    enable = true;
    #package = pkgs.ungoogled-chromium;
    # ungoogled-chrome does not work with extensions for now
    # https://github.com/nix-community/home-manager/issues/2216
    # https://github.com/nix-community/home-manager/issues/2585
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsorblock
      {id = "icallnadddjmdinamnolclfjanhfoafe";} # fastforward
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
      {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
      {id = "gebbhagfogifgggkldgodflihgfeippi";} # return youtube dislike
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
      {id = "njdfdhgcmkocbgbhcioffdbicglldapd";} # localcdn
      {id = "hipekcciheckooncpjeljhnekcoolahp";} # tabliss
      {id = "bgfofngpplpmpijncjegfdgilpgamhdk";} # modern scrollbar
      {id = "ajhmfdgkijocedmfjonnpjfojldioehi";} # privacy pass
      {id = "hkgfoiooedgoejojocmhlaklaeopbecg";} # picture in picture
      #{id = "fnaicdffflnofjppbagibeoednhnbjhg";} # floccus bookmark sync
      #{id = "jaoafjdoijdconemdmodhbfpianehlon";} # skip redirect
      #{id = "dhdgffkkebhmkfjojejmpbldmpobfkfo";} # tampermonkey
      #{id = "jinjaccalgkegednnccohejagnlnfdag";} # violentmonkey
      #{id = "kdbmhfkmnlmbkgbabkdealhhbfhlmmon";} # steamdb
      #{id = "cmeakgjggjdlcpncigglobpjbkabhmjl";} # steam inventory helper
      #{id = "mgijmajocgfcbeboacabfgobmjgjcoja";} # google dictionary
      #{id = "kbfnbcaeplbcioakkpcpgfkobkghlhen";} # grammarly
      #{id = "ekbmhggedfdlajiikminikhcjffbleac";} # 喵喵折+
    ];
  };
}
