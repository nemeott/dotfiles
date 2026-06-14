# Creates a systemd user service to set the volume to 0 and mute on login.
# Have to manually raise volume above 0 (default) AND unmute to hear sound after boot (prevents accidents).

{ pkgs, ... }:

{
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable realtime scheduling
  security.rtkit.enable = true;

  systemd.user.services.mute-audio-on-boot = {
    description = "Mute audio and set volume to zero on boot";

    after = [
      "pipewire.service"
      "wireplumber.service"
    ];

    wants = [
      "pipewire.service"
      "wireplumber.service"
    ];

    wantedBy = [
      "default.target"
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3"; # Slightly hacky but it works (wait for initialization to finish)
      ExecStart = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0";
      ExecStartPost = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 1";
    };
  };
}
