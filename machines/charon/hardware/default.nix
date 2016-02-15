{ config, lib, pkgs, ... }:
{
  imports =
    [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ];
  boot.kernelParams = [ "console=ttyS0" ];
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" "ata_piix" "virtio_pci" ];
  boot.loader.grub.extraConfig = "serial; terminal_input serial; terminal_output serial";
  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/98b261fa-4f9e-4e42-895b-91c17cf145b3";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/b3c7ddd8-fa2f-41ea-b77f-b9a1f434b668";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/eb7f5cd4-6586-47f4-b4cd-c118e3521f17"; }
    ];
}
