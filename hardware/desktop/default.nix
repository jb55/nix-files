{ config, lib, pkgs, ... }:
let
  kindle-opts = ["noatime" "user" "gid=100" "uid=1000" "utf8" "x-systemd.automount"];
in
{
  boot.supportedFilesystems = ["ntfs" "exfat"];

  services.hoogle = {
    enable = true;
    packages = pkgs.myHaskellPackages;
    haskellPackages = pkgs.haskellPackages;
  };

  services.udev.extraRules = ''
    # ds4
    KERNEL=="uinput", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:05C4.*", MODE="0666"

    # rtl-sdr
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2832", MODE="0666", SYMLINK+="rtl_sdr"

    # arduino
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0043", MODE="0666", SYMLINK+="arduino"

    # vive hmd
    KERNEL=="hidraw*", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2c87", MODE="0666"

    # vive lighthouse
    KERNEL=="hidraw*", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2000", MODE="0666"

    # vive controller
    KERNEL=="hidraw*", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2101", MODE="0666"

    # vive audio
    KERNEL=="hidraw*", ATTRS{idVendor}=="0d8c", ATTRS{idProduct}=="0012", MODE="0666"
  '';

  services.xserver.config = ''
    Section "InputClass"
      Identifier "Logitech M705"
      MatchIsPointer "yes"
      Option "AccelerationProfile" "-1"
      Option "ConstantDeceleration" "5"
      Option "AccelerationScheme" "none"
      Option "AccelSpeed" "-1"
    EndSection

    Section "InputClass"
      Identifier "Razer Razer DeathAdder 2013"
      MatchIsPointer "yes"
      Option "AccelerationProfile" "-1"
      Option "ConstantDeceleration" "5"
      Option "AccelerationScheme" "none"
      Option "AccelSpeed" "-1"
    EndSection
  '';

  services.printing.drivers = [ pkgs.samsung-unified-linux-driver_4_01_17 ];

  programs.gnupg.trezor-agent = {
    enable = false;
    configPath = "/home/jb55/.gnupg";
  };

  boot.blacklistedKernelModules = ["dvb_usb_rtl28xxu"];
  fileSystems."/media/kindle" =
    { device = "/dev/kindle";
      fsType = "vfat";
      options = kindle-opts;
    };

  fileSystems."/media/kindledx" =
    { device = "/dev/kindledx";
      fsType = "vfat";
      options = kindle-opts;
    };

  hardware = {
    bluetooth.enable = true;
    pulseaudio = {
      package = pkgs.pulseaudioFull;
      enable = true;
      support32Bit = true;
    };
    opengl.driSupport32Bit = true;
    opengl.driSupport = true;
  };
}
