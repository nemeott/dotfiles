# This script configures audio for a Chromebook with Intel Tiger Lake.
# Uses PulseAudio instead of PipeWire due to better compatibility.
# Creates a systemd user service to set the correct audio profile and mute on login.

# Have to raise volume above 0 (default) AND unmute to hear sound after boot (prevent accidents).

{ pkgs, ... }:

{
  # Use pulseaudio instead of pipewire
  services.pipewire.enable = false;
  services.pulseaudio = {
    enable = true;

    daemon.config = {
      enable-deferred-volume = "no"; # Disable deferred volume to avoid starting in "None" profile
      flat-volumes = "no"; # Prevent apps from changing volume implicitly
    };

    extraConfig = ''
      # Use legacy ALSA profile probing
      load-module module-udev-detect ignore_dB=1 use_ucm=0

      # Below options don't work so we use a systemd service below instead
      # # Force the fallback profile to avoid "None" profile on startup
      # set-card-profile alsa_card.pci-0000_00_1f.3-platform-tgl_rt5682_def \
      #   output:stereo-fallback+input:stereo-fallback

      # # Mute the default sink on startup and set to 0 volume
      # set-sink-mute @DEFAULT_SINK@ 1
      # set-sink-volume @DEFAULT_SINK@ 0
    '';
  };

  # Switch audio sink manually with
  #   pacmd set-card-profile alsa_card.pci-0000_00_1f.3-platform-tgl_rt5682_def output:stereo-fallback+input:stereo-fallback

  # Create a systemd service to switch audio sink and mute on login
  #   Check service status with:
  #     systemctl --user status set_audio_sink_tigerlake.service
  #     journalctl --user -u set_audio_sink_tigerlake.service -b
  #     systemctl --user list-units | rg pulse
  systemd.user.services.set_audio_sink_tigerlake = {
    description = "Switch to working audio sink and mute on login";

    wantedBy = [ "default.target" ];

    # Provide pactl/pacmd
    path = [
      pkgs.pulseaudio
      pkgs.bash
    ];

    # Make sure pulseaudio is running
    after = [
      "pulseaudio.service"
      "pulseaudio.socket"
    ];

    unitConfig = {
      # Avoid hitting start-limit too quickly during boot/login
      StartLimitIntervalSec = 30;
      StartLimitBurst = 200;
    };

    serviceConfig = {
      Type = "oneshot";

      # Retry on failure
      Restart = "on-failure";
      RestartSec = "200ms";
    };

    script = ''
      set -euo pipefail

      # Switch profile (can recreate sinks)
      pactl set-card-profile \
        alsa_card.pci-0000_00_1f.3-platform-tgl_rt5682_def \
        output:stereo-fallback+input:stereo-fallback

      # Apply to the current default sink; if default isn't ready yet,
      # pactl exits nonzero, and systemd will retry shortly.
      pactl set-sink-mute @DEFAULT_SINK@ 1
      pactl set-sink-volume @DEFAULT_SINK@ 0
    '';
  };

  # environment.systemPackages = with pkgs; [
  #   sof-firmware
  # ];

  # boot.extraModprobeConfig = ''
  #   options snd_hda_intel model=generic
  # '';

  # # Use pipewire instead of pulseaudio
  # services.pulseaudio.enable = false;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true; # Expose ALSA sinks
  #   alsa.support32Bit = true; # 32-bit app support
  #   pulse.enable = true; # pactl/pavucontrol compatibility
  #   #jack.enable = true;

  #   # Session manager for pipewire
  #   wireplumber.enable = true;
  # };

  # systemd.user.services.mute_audio_sink = {
  #   description = "Set volume to 0 on startup";
  #   wantedBy = [ "default.target" ];

  #   path = [
  #     pkgs.pipewire
  #     pkgs.wireplumber
  #     pkgs.bash
  #   ];

  #   after = [
  #     "wireplumber.service"
  #     "pipewire-pulse.service"
  #   ];
  #   wants = [
  #     "wireplumber.service"
  #     "pipewire-pulse.service"
  #   ];

  #   unitConfig = {
  #     # Avoid hitting start-limit too quickly during boot/login
  #     StartLimitIntervalSec = 30;
  #     StartLimitBurst = 200;
  #   };

  #   serviceConfig = {
  #     Type = "oneshot";

  #     # Retry on failure
  #     Restart = "on-failure";
  #     RestartSec = "200ms";
  #   };

  #   # Mute the default sink on startup and set to 0 volume
  #   script = ''
  #     set -euo pipefail

  #     wpctl set-volume @DEFAULT_AUDIO_SINK@ 0
  #   '';
  # };

  # # Need to run these commands somehow on startup
  # # wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
  # # wpctl set-volume @DEFAULT_AUDIO_SINK@ 0

  # Enable realtime scheduling
  security.rtkit.enable = true;
}
