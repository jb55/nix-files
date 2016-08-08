{ config, lib, pkgs, ... }:
{
  systemd.services.footswitch = {
    description = "Footswitch Setup";

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = "yes";
    serviceConfig.ExecStart = "${pkgs.footswitch}/bin/footswitch -m alt";
  };

  systemd.services.footswitch-led = {
    description = "Footswitch LED";

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = pkgs.writeScript "footswitch-led" ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.evtest}/bin/evtest /dev/input/by-id/usb-RDing_FootSwitch*event-mouse | \
        stdbuf -oL grep KEY_LEFTALT | \
        stdbuf -oL sed 's/.*value \(.\)$/\1/' | \
        stdbuf -oL tr '2' '1' | \
        while read x; do echo $x > /sys/class/leds/input2::scrolllock/brightness; done
    '';
  };
}
