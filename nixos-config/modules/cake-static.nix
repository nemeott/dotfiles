# https://blog.iodev.org/blog/cake-traffic-shaping-nixos/

{ pkgs, ... }:

{
  boot.kernelModules = [
    "sch_cake"
    "ifb"
  ];

  # Enable CAKE network scheduler to reduce buffer bloat
  systemd.services.sqm-cake = {
    description = "SQM CAKE traffic shaping for PPPoE";
    after = [ "pppd-wan.service" ];
    requires = [ "pppd-wan.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.iproute2
      pkgs.kmod
      pkgs.ethtool
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStart = pkgs.writeShellScript "sqm-cake-start" ''
        # Wait for ppp0 to be fully up
        for i in $(seq 1 30); do
          ip link show ppp0 up >/dev/null 2>&1 && break
          sleep 1
        done

        # Enable UDP GRO forwarding (helps Tailscale)
        ethtool -K ppp0 rx-udp-gro-forwarding on || true

        modprobe sch_cake

        # Egress: 580Mbit (leave headroom under 600Mbit uplink)
        tc qdisc replace dev ppp0 root cake bandwidth 580mbit \
          besteffort overhead 34 mpu 64 pppoe-ptm

        # Create IFB for ingress shaping
        modprobe ifb
        ip link add name ifb-ppp0 type ifb 2>/dev/null || true
        ip link set ifb-ppp0 up

        # Redirect ingress to IFB
        tc qdisc replace dev ppp0 handle ffff: ingress
        tc filter replace dev ppp0 parent ffff: protocol all \
          u32 match u32 0 0 action mirred egress redirect dev ifb-ppp0

        # Ingress: 940Mbit (under 1Gbit downlink)
        tc qdisc replace dev ifb-ppp0 root cake bandwidth 940mbit \
          besteffort wash ingress overhead 34 mpu 64 pppoe-ptm
      '';

      ExecStop = pkgs.writeShellScript "sqm-cake-stop" ''
        tc qdisc del dev ppp0 root 2>/dev/null || true
        tc qdisc del dev ppp0 ingress 2>/dev/null || true
        ip link del ifb-ppp0 2>/dev/null || true
      '';
    };
  };
}
