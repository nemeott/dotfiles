# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Copied from /etc/nixos/hardware-configuration.nix

    # Add nixos-hardware modules for better hardware support
    "${inputs.nixos-hardware}/common/pc/laptop"
    "${inputs.nixos-hardware}/common/cpu/intel/tiger-lake"
    "${inputs.nixos-hardware}/common/gpu/intel/tiger-lake"

    # Custom hardware configuration for Chromebook (audio and keyboard)
    # ./hardware/chrome-device.nix # Audio fix from GitHub
    ./hardware/chrome-audio.nix # Custom audio config to manually set audio profile
    ./hardware/chrome-bluetooth.nix # Bluetooth fix to work around rfkill issue and noctalia toggle bug
    ./hardware/chrome-keyboard.nix # Custom keymap for Chromebook keyboard (with keyd)

    # Modules
    ../../modules/user.nix
    # ../../modules/cinnamon.nix
    ../../modules/niri.nix
    ../../modules/networking.nix

    # Packages
    ../../modules/packages/base.nix
    ../../modules/packages/cli.nix
    ../../modules/packages/dev.nix
    ../../modules/packages/media.nix
    ../../modules/packages/fonts.nix
    ../../modules/packages/productivity.nix
    ../../modules/packages/browsers.nix
    ../../modules/packages/messaging.nix
  ];

  # Enable all firmware (including unfree) for better hardware support
  hardware.enableAllFirmware = true;

  # Use facter for better hardware support
  hardware.facter.reportPath = ./facter.json;
  # Generate facter config file with:
  # sudo nix run nixpkgs#nixos-facter -- -o facter.json

  # Use Lix package manager instead of Nix
  nix.package = pkgs.lixPackageSets.stable.lix;

  # Disable access time updates for better performance (not usually needed by modern programs)
  fileSystems."/".options = [ "noatime" ];

  # Bootloader
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_18; # Use latest linux kernel
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      # Power-saving dirty writeback settings (less disk writes)
      "vm.dirty_writeback_centisecs" = 5000;
      "vm.dirty_expire_centisecs" = 5000;

      # Zram settings
      # "vm.page-cluster" = 0; # Use with zramSwap
      # "vm.swappiness" = 10; # Use normal swap less often

      # Zswap settings
      "vm.swappiness" = 30;
    };

    kernelParams = [
      # Zswap settings
      "zswap.enabled=1" # enables zswap
      "zswap.compressor=zstd" # compression algorithm
      "zswap.zpool=zsmalloc"
      "zswap.max_pool_percent=30" # maximum percentage of RAM that zswap is allowed to use
      "zswap.accept_threshold_percent=90"
      "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure

      # Disable NMI watchdog for performance improvement
      "nmi_watchdog=0"

      # Manage power saving for Intel HDA audio (sed with power-profiles-daemon)
      "snd_hda_intel.power_save=1"
      "snd_hda_intel.power_save_controller=Y"

      "rcu_nocbs=all" # VERY IMPORTANT FOR LOWERING tick_nohz_handler USAGE (went from ~1000 to ~300 idle)
    ];
  };

  # # Enable zram swap for better performance on systems with limited RAM
  # zramSwap = {
  #   enable = true;
  #   algorithm = "zstd";
  #   memoryPercent = 50;
  # };

  # Faster restarts (no waiting for long processes)
  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=10
    DefaultTimeoutStartSec=10
  '';

  # Hibernate after 60 minutes of suspend
  systemd.sleep.settings.Sleep = {
    SuspendThenHibernate = true;
    HibernateDelaySec = "1h";
  };

  services.udev.extraRules = ''
    # Udev rule to set PCI power control to auto for better power management (used with power-profiles-daemon)
    ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"

    # Use powersave on battery and performance when plugged-in
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver"
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance"

    # Let users in video group change backlight without sudo
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/intel_backlight/bl_power"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/intel_backlight/bl_power"
  '';

  # Systemd service to set power profile on boot based on AC state (udev rules don't work on boot)
  systemd.services.power-profile-on-boot = {
    description = "Set power profile based on AC state";
    wantedBy = [ "power-profiles-daemon.service" ];
    after = [ "power-profiles-daemon.service" ];
    script = ''
      if [ "$(cat /sys/class/power_supply/AC/online)" = "1" ]; then
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
      else
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
      fi
    '';
    serviceConfig.Type = "oneshot";
  };

  # Enable power-profiles-daemon for power management
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true; # Let Noctalia-shell detect battery status

  # Enable thermald for thermal management (Intel CPUs)
  services.thermald.enable = true;

  # Enable system76-scheduler for better IO scheduling
  services.system76-scheduler.enable = true;

  # Enable removable media management
  services.devmon.enable = true; # Automatic device mounting
  services.gvfs.enable = true; # Userspace virtual filesystem
  services.udisks2.enable = true; # Disk management

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false; # Don't power on Bluetooth by default
  };
  services.blueman.enable = true;

  # Set time zone and select internationalisation properties
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # # Enable CUPS to print documents.
  # services.printing.enable = true;

  # # Enable thunderbolt management with bolt
  # environment.systemPackages = [ pkgs.bolt ];
  # services.hardware.bolt.enable = true;
  # # Enroll device with: boltctl enroll DEVICE
  # # Temporarily add device with: boltctl authorize DEVICE

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Settings to make builds faster
  nix.daemonIOSchedClass = "best-effort"; # (default)
  nix.daemonCPUSchedPolicy = "batch"; # Optimized for non-interactive tasks
  nix.daemonIOSchedPriority = 2; # Higher priority for IO operations

  # Enable nix-command experimental feature
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # First installation version
  system.stateVersion = "25.11";
}

# Useful commands:

# Hard link identical files in the Nix store to save disk space
# nix store optimise

# nix-collect-garbage (nix-store --gc)
# nix-collect-garbage --delete-older-than ${n}d
