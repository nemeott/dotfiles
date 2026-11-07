{
  config,
  lib,
  pkgs,
  ...
}:

let
  nodes = {
    vnode1 = 17001;
    vnode2 = 17002;
    vnode3 = 17003;
    vnode4 = 17004;
  };
  slurmPkg = config.services.slurm.package;
in
{
  services = {
    slurm = {
      package = pkgs.slurm.overrideAttrs (old: {
        configureFlags = (old.configureFlags or [ ]) ++ [ "--enable-multiple-slurmd" ];
      });

      server.enable = true;
      client.enable = true;
      controlMachine = "icarus";
      clusterName = "local";
      nodeName = [
        "vnode1 NodeAddr=icarus Port=17001 CPUs=1 State=UNKNOWN"
        "vnode2 NodeAddr=icarus Port=17002 CPUs=1 State=UNKNOWN"
        "vnode3 NodeAddr=icarus Port=17003 CPUs=2 State=UNKNOWN"
        "vnode4 NodeAddr=icarus Port=17004 CPUs=2 State=UNKNOWN"
      ];
      partitionName = [ "debug Nodes=vnode[1-4] Default=YES MaxTime=INFINITE State=UP" ];

      # Each slurmd needs its own spool dir / pidfile / log
      extraConfig = ''
        SlurmdSpoolDir=/var/spool/slurmd/%n
        SlurmdPidFile=/run/slurmd/%n.pid
        SlurmdLogFile=/var/log/slurm/slurmd.%n.log
        ReturnToService=2
      '';
    };

    munge.enable = true;
  };

  environment.etc."munge/munge.key" = {
    text = "local-test-key-0123456789-abcdef";
    user = "munge";
    group = "munge";
    mode = "0400";
  };

  systemd.tmpfiles.rules = [
    "d /var/spool/slurmd 0755 root root -"
    "d /var/log/slurm 0755 root root -"
  ]
  ++ lib.mapAttrsToList (n: _: "d /var/spool/slurmd/${n} 0755 root root -") nodes;

  systemd.services = {
    # Disable the stock single-instance slurmd; we run one per node below
    slurmd.enable = lib.mkForce false;
  }
  // lib.mapAttrs' (
    name: _:
    lib.nameValuePair "slurmd-${name}" {
      description = "SLURM compute daemon for ${name}";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "munged.service"
        "slurmctld.service"
      ];
      requires = [ "munged.service" ];
      environment.SLURM_CONF = "${config.services.slurm.etcSlurm}/slurm.conf";
      startLimitIntervalSec = 0;
      serviceConfig = {
        ExecStart = "${slurmPkg}/bin/slurmd -D -N ${name}";
        RuntimeDirectory = "slurmd";
        RuntimeDirectoryPreserve = true;
        Restart = "on-failure";
        RestartSec = 2;
        Delegate = "yes";
      };
    }
  ) nodes;
}
