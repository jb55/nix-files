{ config, lib, pkgs, ... }:
{
  imports =
    [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ];
  boot.kernelParams = [ "console=ttyS0" ];
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" "ata_piix" "virtio_pci" ];
  boot.loader.grub.extraConfig = "serial; terminal_input serial; terminal_output serial";
}
