// Restore disabled functions
user_pref("browser.cache.disk.enable", true);
user_pref("browser.download.always_ask_before_handling_new_types", false);
user_pref("browser.download.useDownloadDir", true);
user_pref("browser.newtabpage.enabled", true);
user_pref("browser.places.speculativeConnect.enabled", true);
user_pref("browser.shell.shortcutFavicons", true);
user_pref("browser.startup.homepage", "about:home");
user_pref("browser.startup.page", 1);
user_pref("network.dns.disablePrefetch", false);
user_pref("network.dns.disablePrefetchFromHTTPS", false);
user_pref("network.http.speculative-parallel-limit", 20);
user_pref("network.predictor.enabled", true);
user_pref("network.prefetch-next", true);
user_pref("privacy.sanitize.sanitizeOnShutdown", false);
user_pref("security.OCSP.enabled", 0);
user_pref("security.pki.crlite_mode", 2);
user_pref("security.remote_settings.crlite_filters.enabled", true);

// Weird stuff that is not disabled
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.privatebrowsing.vpnpromourl", "");
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("extensions.pocket.enabled", false);
user_pref("signon.rememberSignons", false);

// Neat features, nice to have
user_pref("browser.search.separatePrivateDefault", false);
user_pref("browser.tabs.hoverPreview.enabled", true);
user_pref("browser.tabs.inTitlebar", 0);
user_pref("browser.urlbar.suggest.calculator", true);

// Smooth scrolling
user_pref("apz.overscroll.enabled", true);
user_pref("general.smoothScroll", true);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
user_pref("mousewheel.default.delta_multiplier_y", 75);
