{ ... }:

{
  # Enable sound with pulseaudio instead of pipewire
  services.pulseaudio.enable = false;
  # services.pulseaudio = {
  #   enable = true;

  #   daemon.config = {
  #     enable-deferred-volume = "no"; # Disable deferred volume to avoid starting in "None" profile
  #     flat-volumes = "no"; # Prevent apps from changing volume implicitly
  #   };

  #   extraConfig = ''
  #     # Use legacy ALSA profile probing
  #     load-module module-udev-detect ignore_dB=1 use_ucm=0

  #     # Force the fallback profile to avoid "None" profile on startup ! NOT WORKING; ADJUST MANUALLY
  #     set-card-profile alsa_card.pci-0000_00_1f.3-platform-tgl_rt5682_def \
  #       output:stereo-fallback+input:stereo-fallback

  #     # Mute the default sink on startup
  #     set-sink-mute @DEFAULT_SINK@ 1
  #   '';
  # };

  # Disable pipewire services
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    # # Session manager for pipewire
    # wireplumber.enable = false;
  };

  security.rtkit.enable = true;
}
