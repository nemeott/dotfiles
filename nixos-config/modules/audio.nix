{ ... }:

{
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    # wireplumber.enable = true;
  };

  # hardware.firmware = [ pkgs.sof-firmware ]; # Install SOF firmware for Intel audio
  # hardware.enableAllFirmware = true;
  # boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1" ];
}
