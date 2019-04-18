{ config, lib, pkgs, ... }:
{
  # fileSystems."/" =
  #   { device = "/dev/disk/by-uuid/62518649-0872-49e2-a269-34975e314c6a";
  #     fsType = "ext4";
  #   };

  # fileSystems."/" =
  #   { device = "/dev/nvme0n1p1";
  #     fsType = "zfs";
  #nixos-generate-config --root /mnt   };

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.loader.grub.copyKernels = true;
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "znix/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "znix/home";
      fsType = "zfs";
    };

  fileSystems."/zbig" =
    { device = "zbig";
      fsType = "zfs";
    };

  #fileSystems."/vr" =
  # { device = "/dev/disk/by-uuid/E234A89834A87169";
  #   fsType = "ntfs";
  # };

  #fileSystems."/sand" =
  #  { device = "/dev/disk/by-uuid/2ee709b8-7e83-470f-91bc-d0b0ba59b945";
  #    fsType = "ext4";
  #  };

  # fileSystems."/home/jb55/shares/will-vm/projects" =
  #   { device = "//192.168.86.199/Users/jb55/projects";
  #     fsType = "cifs";
  #     options = ["username=jb55" "password=notsecurepw" "gid=100" "uid=1000"];
  #   };

  #fileSystems."/home/jb55/.local/share/Steam/steamapps" =
  #  { device = "/sand/data/SteamAppsLinux";
  #    fsType = "none";
  #    options = ["bind"];
  #  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d4e4ae51-9179-439d-925b-8df42dd1bfc5"; }
    ];

  hardware.enableAllFirmware = true;

  boot.loader.grub.devices = [ "/dev/nvme0n1" ];
  boot.supportedFilesystems = ["zfs"];
}
