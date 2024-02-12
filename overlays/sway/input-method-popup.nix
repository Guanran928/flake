{addPatches, ...}: _final: prev: {
  sway-unwrapped = addPatches prev.sway-unwrapped [
    # Tray D-Bus Menu
    # https://github.com/swaywm/sway/pull/6249
    (prev.runCommand "2f304ef0532a45d00b2ec2c7fc63adef0aec7607.patch" {} ''
      cat ${prev.fetchpatch {
        url = "https://github.com/swaywm/sway/commit/2f304ef0532a45d00b2ec2c7fc63adef0aec7607.patch";
        hash = "sha256-nd+Z6A7GE5Go7QxXOI+hiLWQiXegsQatcNfxEsXgamI=";
      }} | sed "s/int surface_x, surface_y, surface_width, surface_height;/int surface_x, surface_y, surface_width, surface_height = 0;/g" > $out
    '')
  ];
}
