{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brightnessctl
    # Custom brightness control scripts (0%, 1, 1%, 5%, 10%, ...)
    (writeShellApplication {
      name = "brightness_down";
      runtimeInputs = [ brightnessctl ];
      text = ''
        value=$(brightnessctl -m | cut -d, -f3 | sed 's/%//')
        percent=$(brightnessctl -m | cut -d, -f4 | sed 's/%//')
        if [ "$value" -le 1 ]; then
            brightnessctl --class=backlight set 0%
            echo 1 | tee /sys/class/backlight/intel_backlight/bl_power
        elif [ "$percent" -le 1 ]; then
            brightnessctl --class=backlight set 1
        elif [ "$percent" -le 5 ]; then
            brightnessctl --class=backlight set 1%
        else
            brightnessctl --class=backlight set 5%-
        fi
      '';
    })
    (writeShellApplication {
      name = "brightness_up";
      runtimeInputs = [ brightnessctl ];
      text = ''
        value=$(brightnessctl -m | cut -d, -f3 | sed 's/%//')
        percent=$(brightnessctl -m | cut -d, -f4 | sed 's/%//')
        if [ "$value" -eq 0 ]; then
            echo 0 | tee /sys/class/backlight/intel_backlight/bl_power
            brightnessctl --class=backlight set 1
        elif [ "$value" -eq 1 ]; then
            brightnessctl --class=backlight set 1%
        elif [ "$percent" -eq 1 ]; then
            brightnessctl --class=backlight set 5%
        else
            brightnessctl --class=backlight set +5%
        fi
      '';
    })
  ];
}
