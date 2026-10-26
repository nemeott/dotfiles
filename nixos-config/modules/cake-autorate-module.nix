{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.cake-autorate;
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;

  kbit = n: "${toString n}kbit";

  # Ceiling for the adaptive shaper: measured speed scaled by percent
  dlMax = cfg.download.speed * cfg.percent / 100;
  ulMax = cfg.upload.speed * cfg.percent / 100;

  setup = pkgs.writeShellApplication {
    name = "cake-autorate-setup";
    runtimeInputs = [
      pkgs.iproute2
      pkgs.kmod
    ];
    text = ''
      modprobe sch_cake
      modprobe ifb

      # Egress: CAKE directly on the interface, starting at the base rate
      tc qdisc replace dev ${cfg.interface} root cake \
        bandwidth ${kbit cfg.upload.base} ${cfg.cakeArgs.egress}

      # Ingress: redirect to an IFB device and shape there
      ip link add name ${cfg.ifbInterface} type ifb 2>/dev/null || true
      ip link set ${cfg.ifbInterface} up
      tc qdisc replace dev ${cfg.interface} handle ffff: ingress
      tc filter replace dev ${cfg.interface} parent ffff: protocol all \
        u32 match u32 0 0 action mirred egress redirect dev ${cfg.ifbInterface}
      tc qdisc replace dev ${cfg.ifbInterface} root cake \
        bandwidth ${kbit cfg.download.base} ${cfg.cakeArgs.ingress}
    '';
  };

  teardown = pkgs.writeShellApplication {
    name = "cake-autorate-teardown";
    runtimeInputs = [ pkgs.iproute2 ];
    text = ''
      tc qdisc del dev ${cfg.interface} root 2>/dev/null || true
      tc qdisc del dev ${cfg.interface} ingress 2>/dev/null || true
      ip link del ${cfg.ifbInterface} 2>/dev/null || true
    '';
  };

  deviceUnit = "sys-subsystem-net-devices-${
    builtins.replaceStrings [ "-" ] [ "\\x2d" ] cfg.interface
  }.device";

  rateOptions = dir: defaults: {
    speed = mkOption {
      type = types.ints.positive;
      example = 450000;
      description = ''
        Best ${dir} speed you have measured on this link, in kbit/s.
        The shaper's maximum is this value scaled by `percent`.
      '';
    };
    min = mkOption {
      type = types.ints.positive;
      default = defaults.min;
      description = "Minimum ${dir} shaper rate in kbit/s (always bufferbloat-free).";
    };
    base = mkOption {
      type = types.ints.positive;
      default = defaults.base;
      description = "Steady-state ${dir} shaper rate in kbit/s.";
    };
  };
in
{
  options.services.cake-autorate = {
    enable = mkEnableOption "cake-autorate adaptive CAKE shaping";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Start the service at boot. When false, the service is installed but
        stays off until you run `systemctl start cake-autorate`.
      '';
    };

    package = lib.mkPackageOption pkgs "cake-autorate" { };

    interface = mkOption {
      type = types.str;
      example = "wlp0s20f3";
      description = "Network interface to shape (egress directly, ingress via IFB).";
    };

    ifbInterface = mkOption {
      type = types.strMatching "[A-Za-z0-9_.-]{1,15}";
      default = "ifb-wifi";
      description = "IFB device used for ingress shaping (max 15 characters).";
    };

    percent = mkOption {
      type = types.ints.between 1 100;
      default = 95;
      description = ''
        Maximum shaper rate as a percentage of the measured `speed`, applied
        to both directions. Lower values leave more headroom (better latency,
        lower peak throughput).
      '';
    };

    download = rateOptions "download" {
      min = 5000;
      base = 20000;
    };
    upload = rateOptions "upload" {
      min = 5000;
      base = 20000;
    };

    cakeArgs = {
      egress = mkOption {
        type = types.str;
        default = "besteffort";
        description = "Extra CAKE keywords for the egress qdisc.";
      };
      ingress = mkOption {
        type = types.str;
        default = "besteffort wash ingress";
        description = "Extra CAKE keywords for the ingress (IFB) qdisc.";
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra shell lines appended to config.primary.sh (the overrides section).
        See defaults.sh in the cake-autorate source for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.download.min <= cfg.download.base && cfg.download.base <= dlMax;
        message = "services.cake-autorate: need download.min <= download.base <= speed * percent / 100 (${toString dlMax} kbit/s).";
      }
      {
        assertion = cfg.upload.min <= cfg.upload.base && cfg.upload.base <= ulMax;
        message = "services.cake-autorate: need upload.min <= upload.base <= speed * percent / 100 (${toString ulMax} kbit/s).";
      }
    ];

    boot.kernelModules = [
      "sch_cake"
      "ifb"
    ];

    # https://github.com/lynxthecat/cake-autorate/blob/master/config.primary.sh
    environment.etc."cake-autorate/config.primary.sh".text = ''
      #!/usr/bin/env bash
      # shellcheck disable=SC2034

      # *** INSTANCE-SPECIFIC CONFIGURATION OPTIONS ***
      #
      # cake-autorate will run one instance per config file present in the directory where
      # cake-autorate is found (typically /root/cake-autorate). The config files must be in
      # the directory in the form: config.instance.sh. Thus multiple instances of cake-autorate
      # can be established by setting up appropriate config files like config.primary.sh and
      # config.secondary.sh for the respective first and second instances of cake-autorate.

      ### For multihomed setups, it is the responsibility of the user to ensure that the probes
      ### sent by this instance of cake-autorate actually travel through these interfaces.
      ### See ping_extra_args and ping_prefix_string

      dl_if=${cfg.ifbInterface} # download interface
      ul_if=${cfg.interface} # upload interface

      # Set either of the below to 0 to adjust one direction only
      # or alternatively set both to 0 to simply use cake-autorate to monitor a connection
      adjust_dl_shaper_rate=1 # enable (1) or disable (0) actually changing the dl shaper rate
      adjust_ul_shaper_rate=1 # enable (1) or disable (0) actually changing the ul shaper rate

      min_dl_shaper_rate_kbps=${toString cfg.download.min}  # minimum bandwidth for download (Kbit/s)
      base_dl_shaper_rate_kbps=${toString cfg.download.base} # steady state bandwidth for download (Kbit/s)
      max_dl_shaper_rate_kbps=${toString dlMax}  # maximum bandwidth for download (Kbit/s)

      min_ul_shaper_rate_kbps=${toString cfg.upload.min}  # minimum bandwidth for upload (Kbit/s)
      base_ul_shaper_rate_kbps=${toString cfg.upload.base} # steady state bandwidth for upload (KBit/s)
      max_ul_shaper_rate_kbps=${toString ulMax}  # maximum bandwidth for upload (Kbit/s)

      connection_active_thr_kbps=2000  # threshold in Kbit/s below which dl/ul is considered idle

      # Logging toggles for various stats
      output_processing_stats=0 # enable (1) or disable (0) output monitoring lines showing processing stats
      output_load_stats=0       # enable (1) or disable (0) output monitoring lines showing achieved loads
      output_reflector_stats=0  # enable (1) or disable (0) output monitoring lines showing reflector stats
      output_summary_stats=0    # enable (1) or disable (0) output monitoring lines showing summary stats
      output_cpu_stats=0        # enable (1) or disable (0) output monitoring lines showing CPU usage percentages
      output_cpu_raw_stats=0    # enable (1) or disable (0) output monitoring lines showing raw CPU usage lines

      # *** OVERRIDES ***

      ### See defaults.sh for additional configuration options
      ### that can be set in this configuration file to override the defaults.
      ### Place any such overrides below this line.

      ${cfg.extraConfig}
    '';

    systemd.services.cake-autorate = {
      description = "CAKE with adaptive bandwidth (cake-autorate)";
      wantedBy = lib.optional cfg.autoStart "multi-user.target";
      bindsTo = [ deviceUnit ];
      after = [ deviceUnit ];
      restartTriggers = [ config.environment.etc."cake-autorate/config.primary.sh".source ];

      serviceConfig = {
        ExecStartPre = "${setup}/bin/cake-autorate-setup";
        ExecStart = "${cfg.package}/bin/cake-autorate /etc/cake-autorate/config.primary.sh";
        ExecStopPost = "-${teardown}/bin/cake-autorate-teardown";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
