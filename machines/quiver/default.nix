extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ../../misc/msmtp extra)
    (import ./networking extra)
    (import ./imap-notifier extra)
    (import ./timers extra)
  ];

  virtualisation.docker.enable = false;

  boot.extraModprobeConfig = ''
    options thinkpad_acpi enabled=0
  '';

  services.hoogle = {
    enable = true;
    packages = pkgs.myHaskellPackages;
    haskellPackages = pkgs.haskellPackages;
  };
  services.mongodb.enable = true;
  services.redis.enable = true;

  services.xserver.libinput.enable = true;
  services.xserver.config = ''
    Section "InputClass"
      Identifier     "Enable libinput for TrackPoint"
      MatchProduct   "TPPS/2 IBM TrackPoint"
      Driver         "libinput"
      Option         "ScrollMethod" "button"
      Option         "ScrollButton" "8"
      Option         "AccelSpeed" "0"
    EndSection

    Section "InputClass"
      Identifier       "Disable TouchPad"
      MatchIsTouchpad  "on"
      Driver           "libinput"
      Option           "Ignore" "true"
    EndSection
  '';


  services.plex = {
    enable = false;
    openFirewall = true;
  };

  services.nginx.enable = true;
  services.nginx.group = "www-data";

  services.nginx.httpConfig = ''
    server {
      listen 80;

      root /var/www/share;

      location / {
        autoindex on;
      }
    }
  '';

  users.extraGroups.www-data.members = [ "jb55" ];

  # https://github.com/nmikhailov/Validity90  # driver not done yet
  services.fprintd.enable = false;
  services.printing.drivers = [ pkgs.samsung-unified-linux-driver_4_01_17 ];

  services.autorandr.enable = true;
  services.acpid.enable = false;
  powerManagement.enable = false;

  networking.wireless.enable = true;

  programs.gnupg.trezor-agent = {
    enable = true;
    configPath = "/home/jb55/.gnupg";
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.6/";
    enable = true;
    # extraPlugins = with pkgs; [ pgmp ];
    authentication = pkgs.lib.mkForce ''
      # type db  user address            method
      local  all all                     trust
    '';
    # extraConfig = ''
    #   listen_addresses = '172.24.172.226,127.0.0.1'
    # '';
  };

}
