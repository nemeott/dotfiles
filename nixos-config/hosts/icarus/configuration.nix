# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix # Copied from /etc/nixos/hardware-configuration.nix

    # Add nixos-hardware modules for better hardware support
    "${inputs.nixos-hardware}/common/pc/laptop"
    "${inputs.nixos-hardware}/common/cpu/intel/tiger-lake"
    "${inputs.nixos-hardware}/common/gpu/intel/tiger-lake"

    # Custom hardware configuration for Chromebook (audio and keyboard)
    ./hardware/chrome-audio.nix # Audio fix from GitHub
    ./hardware/chrome-bluetooth.nix # Bluetooth fix to work around rfkill issue and noctalia toggle bug
    ./hardware/chrome-keyboard.nix # Custom keymap for Chromebook keyboard (with keyd)

    # Modules
    ../../modules/user.nix
    # ../../modules/cinnamon.nix
    ../../modules/niri.nix
    ../../modules/networking.nix
    ../../modules/audio.nix
    # ../../modules/zswap.nix
    ../../modules/zram.nix

    # Packages
    ../../modules/packages/base.nix
    ../../modules/packages/cli.nix
    ../../modules/packages/dev.nix
    ../../modules/packages/firefox.nix
    ../../modules/packages/fonts.nix
    ../../modules/packages/helium-browser.nix
    ../../modules/packages/media.nix
    ../../modules/packages/messaging.nix
    ../../modules/packages/productivity.nix
    ../../modules/packages/zen-browser.nix
  ];

  hardware = {
    # Enable all firmware (including unfree) for better hardware support
    enableAllFirmware = true;

    # Use facter for better hardware support
    facter = {
      reportPath = ./facter.json;
      # Generate facter config file with:
      # sudo nix run nixpkgs#nixos-facter -- -o facter.json

      # Manually set this to remove ip6tnl0 since the new facter report removed this (from my device at least)
      detected.dhcp.interfaces = [ "wlp0s20f3" ];
    };
  };

  # Use Lix package manager instead of Nix
  # Override packages that use Nix to use Lix instead
  # Overlay help: https://github.com/NixOS/nixpkgs/pull/445223#issuecomment-3330902652
  nixpkgs.overlays = [
    (final: prev: {
      nix = final.lixPackageSets.latest.lix;

      inherit (final.lixPackageSets.latest)
        nixpkgs-review
        nurl
        nix-init
        nix-update
        nix-direnv
        nil
        # nixd
        # nix-eval-jobs
        nix-fast-build
        colmena
        ;

      lixPackageSets = prev.lixPackageSets.override {
        inherit (prev)
          nixpkgs-review
          nurl
          nix-init
          nix-update
          nix-direnv
          nil
          # nixd
          # nix-eval-jobs
          nix-fast-build
          colmena
          ;
      };
    })
  ];

  fileSystems."/".options = [
    "noatime" # Disable access time updates for better performance (not usually needed by modern programs)
    "commit=15" # Flush ext4 journal to disk less to reduce write operations (5s default)
  ];

  # Battery draw under load much less than default from my testing (https://github.com/nemeott/scx_benchmark)
  # Also helps latency for interactive workloads
  # services.scx = {
  # enable = true;
  # scheduler = "scx_bpfland";
  # scheduler = "scx_cake";
  # scheduler = "scx_cosmos";
  # extraArgs = [ "-m powersave" ]; # TODO: Switch when battery mode switches
  # scheduler = "scx_lavd";
  # extraArgs = [ "--autopower" ];
  # scheduler = "scx_pandemonium";
  # };

  # Profile Linux kernel modules to help build minimal config later
  environment.systemPackages = [ pkgs.modprobed-db ];
  systemd = {
    packages = [ pkgs.modprobed-db ];

    # Auto start the services
    user = {
      services.modprobed-db = {
        wantedBy = [ "default.target" ];
        path = with pkgs; [
          kmod
          coreutils
          gawk
          gnugrep
          gnused
          findutils
          getent
        ];
        serviceConfig.ExecStart = [
          "" # Clear hardcoded /usr/bin path
          "${pkgs.modprobed-db}/bin/modprobed-db storesilent" # systemctl --user cat modprobed-db | rg 'Exec|Type'
        ];
      };
      timers.modprobed-db.wantedBy = [ "timers.target" ];
    };
  };
  # TODO: Check these: https://github.com/NotAShelf/bunker-patches/blob/08f95845ae8b3749453a0ac16ca581aab2028af3/module.nix#L888

  # Bootloader
  boot = {
    # Check for latest kernel versions here: https://www.kernel.org/
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_18; # LTS
    # kernelPackages = pkgs.linuxKernel.packages.linux_7_3;

    # Build kernel natively with Clang Thin LTO (https://liassica.dev/posts/0004-clang-linux-nixos)
    kernelPackages =
      let
        kernel = pkgs.linux_7_3;
        llvm = pkgs.llvmPackages_latest;
      in
      # Generate kernel modules for our custom kernel
      pkgs.linuxPackagesFor (
        kernel.override {
          # Set chosen version of LLVM as our standard environment
          stdenv = pkgs.overrideCC llvm.stdenv (
            # Tell our C compiler (Clang) to use LLVM bintools
            # normally GNU binutils are used even with Clang as the compiler
            llvm.stdenv.cc.override { inherit (llvm) bintools; }
          );

          extraMakeFlags = [ "LLVM=1" ]; # Compile with Clang and LLVM

          argsOverride = {
            modDirVersion = "${kernel.modDirVersion}-native-thinlto"; # Update module directory name to match kernel name
          };
          structuredExtraConfig = with lib.kernel; {
            LOCALVERSION = freeform "-native-thinlto"; # Appended to kernel name
            X86_NATIVE_CPU = yes; # Build natively
            LTO_CLANG_THIN = yes; # Clang Thin LTO (faster builds and decrease runtime memory usage)

            # Rust not available, so ignore modules that require it
            RUST = lib.mkOverride 40 unset;
            NOVA_CORE = lib.mkOverride 40 unset;
            DRM_NOVA = lib.mkOverride 40 unset;
            DRM_PANIC_SCREEN_QR_CODE = lib.mkOverride 40 unset;
          };
        }
      );

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      # Power-saving dirty writeback settings (less disk writes)
      "vm.dirty_writeback_centisecs" = 5000;
      "vm.dirty_expire_centisecs" = 5000;
    };

    kernelParams = [
      # Disable NMI watchdog for performance improvement
      "nmi_watchdog=0"

      # Manage power saving for Intel HDA audio (sed with power-profiles-daemon)
      "snd_hda_intel.power_save=1"
      "snd_hda_intel.power_save_controller=Y"

      "pcie_aspm.policy=powersupersave"
      "i915.i915_enable_rc6=1" # Enable RC6 deep sleep state for Intel GPU
      "i915.i915_enable_fbc=1" # Enable frame buffer compression (less memory bandwidth and lower power usage)

      "rcu_nocbs=all" # VERY IMPORTANT FOR LOWERING tick_nohz_handler USAGE (went from ~1000 to ~300 idle)
      "rcutree.enable_rcu_lazy=1" # Enable lazy RCU for +5-10% battery savings (slightly worse disk I/O)
    ];
  };

  systemd = {
    # Enable HWP dynamic boost for better performance when needed (slightly higher battery usage)
    tmpfiles.rules = [
      "w /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost - - - - 1"
    ];

    # Faster restarts (no waiting for long processes)
    user.settings.Manager = {
      DefaultTimeoutStopSec = 10;
      DefaultTimeoutStartSec = 10;
    };

    # Hibernate after 60 minutes of suspend
    sleep.settings.Sleep.HibernateDelaySec = "1h";
  };
  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "suspend-then-hibernate";
    };

    # Auto-nice daemon to improve responsiveness and reduce lag during resource-heavy workloads
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };

    earlyoom.enable = true; # Better OOM handling

    udev.extraRules = ''
      # Udev rule to set PCI and USB power control to auto for better power management (used with power-profiles-daemon)
      ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"

      # Disable auto for Wireless Logitech mouse (fixes lag after not using mouse for a while)
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c548", TEST=="power/control", ATTR{power/control}="on"

      # Let users in video group change backlight without sudo
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/intel_backlight/bl_power"
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/intel_backlight/bl_power"

    '';

    # Enable power-profiles-daemon for power management
    power-profiles-daemon.enable = true;
    upower.enable = true; # Let Noctalia-shell detect battery status

    # Enable thermald for thermal management (Intel CPUs)
    thermald.enable = true;

    # Enable removable media management
    devmon.enable = true; # Automatic device mounting
    gvfs.enable = true; # Userspace virtual filesystem
    udisks2.enable = true; # Disk management

    # More efficient time synchronization for laptops
    chrony.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false; # Don't power on Bluetooth by default
  };
  services.blueman.enable = true;

  # Set time zone and select internationalisation properties
  time.timeZone = "America/New_York";

  # # Enable CUPS to print documents.
  # services.printing.enable = true;

  # # Enable thunderbolt management with bolt
  # environment.systemPackages = [ pkgs.bolt ];
  # services.hardware.bolt.enable = true;
  # # Enroll device with: boltctl enroll DEVICE
  # # Temporarily add device with: boltctl authorize DEVICE

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Settings to make builds faster
  nix = {
    daemonIOSchedClass = "best-effort"; # (default)
    daemonCPUSchedPolicy = "batch"; # Optimized for non-interactive tasks
    daemonIOSchedPriority = 2; # Higher priority for IO operations

    # Enable flakes
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      keep-derivations = true; # Default
      keep-outputs = true; # Keep build outputs for fast package rebuilds
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d"; # Keep previous week
      dates = "weekly"; # Monday at midnight
      persistent = true; # Do after reboot if system was shut down early
      randomizedDelaySec = "300"; # Random delay to avoid running at the same time as other services (5 min)
    };
    optimise = {
      automatic = true;
      dates = "weekly"; # Monday at midnight
      persistent = true; # Do after reboot if system was shut down early
      randomizedDelaySec = "300"; # Random delay to avoid running at the same time as other services (5 min)
    };
  };

  # Don't build NixOS manual to improve build times
  documentation.nixos.enable = false; # ~5 sec

  # First installation version
  system.stateVersion = "25.11";
}

# Useful commands:

# Hard link identical files in the Nix store to save disk space
# nix store optimise

# nix-collect-garbage (nix-store --gc)
# nix-collect-garbage --delete-older-than ${n}d
