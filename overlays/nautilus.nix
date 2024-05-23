{prev, ...}: {
  gnome =
    prev.gnome
    // {
      # https://aur.archlinux.org/pkgbase/nautilus-typeahead
      nautilus = prev.gnome.nautilus.overrideAttrs {
        src = prev.fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "albertvaka";
          repo = "nautilus";
          rev = "f5f593bf36c41756a29d5112a10cf7ec70b8eafb";
          hash = "sha256-PfkCY2gQ8jfPIgTRC9Xzxh4N3f2oB339Hym5RCbKwkw=";
        };

        # Enable type-ahead behavior by default
        postPatch = ''
          awk -i inplace '/type-ahead-search/{c++;} c==1 && /true/{sub("true", "false"); c++;} 1' data/org.gnome.nautilus.gschema.xml
        '';
      };
    };
}
