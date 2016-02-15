{ config, lib, pkgs, ... }:
{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/62518649-0872-49e2-a269-34975e314c6a";
      fsType = "ext4";
    };

  fileSystems."/sand" =
    { device = "/dev/disk/by-uuid/2ee709b8-7e83-470f-91bc-d0b0ba59b945";
      fsType = "ext4";
    };

  fileSystems."/home/jb55/.local/share/Steam/steamapps" =
    { device = "/sand/data/SteamAppsLinux";
      fsType = "none";
      options = "bind";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d4e4ae51-9179-439d-925b-8df42dd1bfc5"; }
    ];

  boot.loader.grub.device = "/dev/sda";
}
