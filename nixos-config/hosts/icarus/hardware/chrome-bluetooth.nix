{ pkgs, ... }:

{
  # rfkill please don't kill my bluetooth
  systemd.services.systemd-rfkill = {
    postStart = ''
      ${pkgs.util-linux}/bin/rfkill unblock bluetooth
    '';
  };

  # Systemd script of hopes and prayers (hacky but works, increase sleep time if it doesn't)
  # Turn off bluetooth after Noctalia fully starts (fixes Noctalia bluetooth toggle not working)
  systemd.user.services.noctalia-bluetooth-fix = {
    description = "Power off Bluetooth after Noctalia fully starts";

    wantedBy = [ "default.target" ];
    after = [ "niri.service" ];

    # Let quickshell initialize, then turn off bluetooth
    script = ''
      sleep 5 # Pray noctalia shell is fully started after this
      ${pkgs.bluez}/bin/bluetoothctl power off
    '';
  };
}
