{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.footswitch;

in {

  options.services.footswitch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable foot switch";
    };

    enable-led = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable foot switch led";
    };

    led = mkOption {
      type = types.string;
      default = "input2::scrolllock";
      example = "input2::scrolllock";
      description = "/sys/class/leds/<led> to turn on when foot switch is pressed";
    };

    args = mkOption {
      type = types.string;
      default = "-m alt";
      example = "-m ctrl";
      description = "footswitch arguments";
    };

  };

  config = mkIf cfg.enable {
    systemd.services.footswitch = {
      description = "Footswitch Setup";

      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = "yes";
      serviceConfig.ExecStart = "${pkgs.footswitch}/bin/footswitch ${cfg.args}";
    };


    systemd.services.footswitch-led = mkIf cfg.enable-led {
      description = "Footswitch LED";

      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "simple";
      serviceConfig.ExecStart = pkgs.writeScript "footswitch-led" ''
        #!${pkgs.bash}/bin/bash
        ${pkgs.evtest}/bin/evtest /dev/input/by-id/usb-RDing_FootSwitch1F1.-event-kbd | \
          stdbuf -oL grep KEY_ | \
          stdbuf -oL sed 's/.*value \(.\)$/\1/' | \
          stdbuf -oL tr '2' '1' | \
          while read x; do echo $x > /sys/class/leds/${cfg.led}/brightness; done
      '';
    };
  };


}
