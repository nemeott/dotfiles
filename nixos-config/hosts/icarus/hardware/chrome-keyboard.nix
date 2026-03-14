# Extracted from chrome-device.nix
{ ... }:

{
  # Makes touchpad disable while typing work (probably?)
  # Optional, but makes sure that when you type the make palm rejection work with keyd
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';

  services.keyd = {
    enable = true;
    keyboards.internal = {
      # Which keyboard ids to enable for (sudo keyd monitor)
      ids = [
        "k:0001:0001"
        "k:18d1:5044"
        "k:18d1:5052"
        "k:0000:0000"
        "k:18d1:5050"
        "k:18d1:504c"
        "k:18d1:503c"
        "k:18d1:5030"
        "k:18d1:503d"
        "k:18d1:505b"
        "k:18d1:5057"
        "k:18d1:502b"
        "k:18d1:5061"
      ];
      settings = {
        main = {
          # esc = "esc";
          # back = "back";
          # refresh = "refresh";
          zoom = "f11";
          # scale = "scale";
          # sysrq = "sysrq"; # Screenshot key
          # brightnessdown = "brightnessdown";
          # brightnessup = "brightnessup";
          # mute = "mute";
          # volumedown = "volumedown";
          # volumeup = "volumeup";
          sleep = "coffee";
        };
        meta = {
          # Top keys corespond to F1-F12 when Mod/Meta held
          esc = "f1";
          back = "f2";
          refresh = "f3";
          zoom = "f4";
          scale = "f5";
          sysrq = "f6"; # Screenshot key
          brightnessdown = "f7";
          brightnessup = "f8";
          mute = "f9";
          volumedown = "f10";
          volumeup = "f11";
          sleep = "f12";
        };
        alt = {
          backspace = "delete";
          meta = "capslock";
          brightnessdown = "kbdillumdown";
          brightnessup = "kbdillumup";
        };
        # rightalt on Chromebook is altgr for some reason
        altgr = {
          up = "pageup";
          down = "pagedown";
        };
        controlalt = {
          backspace = "C-A-delete";
        };
      };
    };
  };
}
