{ config, lib, pkgs, ... }:
let
  kindle-opts = ["noatime" "user" "gid=100" "uid=1000" "utf8" "x-systemd.automount"];
in
{
  boot.supportedFilesystems = ["ntfs" "exfat"];

  services.udev.extraRules = ''
    # coldcard
    KERNEL=="hidraw*", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", GROUP="plugdev", MODE="0666", SYMLINK+="coldcard

    # yubikey neo
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0116", MODE="0666"

    # yubikey4
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", MODE="0666"

    # kindle
    ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0004", SYMLINK+="kindle"
    ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0003", SYMLINK+="kindledx"

    # HTC Vive HID Sensor naming and permissioning
    # vive hmd
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2c87", TAG+="uaccess"

    # vive controller
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2101", TAG+="uaccess"

    # vive lighthouse
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2000", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="1043", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2050", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2011", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2012", TAG+="uaccess"

    # vive audio
    KERNEL=="hidraw*", ATTRS{idVendor}=="0d8c", ATTRS{idProduct}=="0012", MODE="0666"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2c87", TAG+="uaccess"

    # HTC Camera USB Node
    SUBSYSTEM=="usb", ATTRS{idVendor}=="114d", ATTRS{idProduct}=="8328", TAG+="uaccess"

    # HTC Mass Storage Node
    SUBSYSTEM=="usb", ATTRS{idVendor}=="114d", ATTRS{idProduct}=="8200", TAG+="uaccess"

    # ds4
    KERNEL=="uinput", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:05C4.*", MODE="0666"

    # Nintendo Switch Pro Controller over USB hidraw
    #KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666"

    # Nintendo Switch Pro Controller over bluetooth hidraw
    #KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0666"

    # rtl-sdr
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2832", MODE="0666", SYMLINK+="rtl_sdr"

    # arduino
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0043", MODE="0666", SYMLINK+="arduino"
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
