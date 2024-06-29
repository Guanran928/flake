# About this device

### Hardware

```
$ hostnamectl --json short | jq -r '.HardwareVendor, .HardwareModel'
Apple Inc.
MacBookPro11,3
```

### Description

Homelab, hosting random stuff through tailscale and rathole.

### TODOs:

- [ ] backlight is always 33% when booted up
- [ ] encrypted swap
- [ ] impermanence
- [ ] luks1 -> luks2
  - [ ] tpm luks unlocking
- [ ] nouveau -> nvidia
- [x] networkmanager -> iwd
- [ ] jellyfin hardware acceleration
