{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet -t --time-format '%F %H:%M:%S' --remember --remember-user-session --asterisks --asterisks-char '*' --window-padding 2";
    };
    useTextGreeter = true;
  };

  # Hide audio error messages on the greeter
  systemd.services.suppress-console-noise = {
    description = "Suppress kernel console messages during greeter";
    wantedBy = [ "greetd.service" ];
    before = [ "greetd.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/dmesg --console-level 1";
    };
  };

  security.pam = {
    # Use swaylock for authentication
    services.swaylock = { };

    # Allow any program run by users group to request real-time priority
    # Improves latency and reduces stuttering (https://wiki.nixos.org/wiki/Sway)
    loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }
    ];
  };

}
