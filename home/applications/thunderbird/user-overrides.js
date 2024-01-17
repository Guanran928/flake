// Cache related.
// I have stupidly slow Internet connection and also on a proxy.
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.cache.memory.capacity", 1);
user_pref("privacy.clearOnShutdown.cache", false);
user_pref("mail.imap.use_disk_cache2", true);


// View related.
// Makes messages prettier.
user_pref("permissions.default.image", 1);
user_pref("mailnews.display.disallow_mime_handlers", 0);
user_pref("mailnews.display.html_as", 0);
user_pref("mailnews.message_display.disable_remote_image", false);

// user_pref("privacy.resistFingerprinting", false);
user_Pref("mail.shell.checkDefaultClient", false);