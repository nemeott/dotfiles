# Bash Files and NixOS Config

Currently using X11 and Cinnamon but working on switching to Wayland and Niri.

## Hosts
**`icarus`** - Acer Chromebook Spin 713 (CP713-3W)

Uses a custom chromebook NixOS keyboard/audio fixer script `chrome-device.nix` from [https://github.com/dj1ch/nixos-chromebook](https://github.com/dj1ch/nixos-chromebook). I also wrote my own audio script `chrome-audio.nix` since the audio card was not being set correctly on boot. It uses a custom oneshot systemd startup script to set the card profile to a fallback option which works well on Cinnamon. It also sets the volume to 0 by default.
