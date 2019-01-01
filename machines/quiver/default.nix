extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ../../misc/msmtp extra)
    (import ./networking extra)
    (import ../../misc/imap-notifier extra)
    (import ./timers extra)
  ];

  environment.systemPackages = with pkgs; [ acpi xorg.xbacklight ];

  virtualisation.docker.enable = false;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "jb55" ];

  documentation.nixos.enable = false;

  boot.extraModprobeConfig = ''
    options thinkpad_acpi enabled=0
  '';


  # telepathy is a garbage fire
  services.telepathy.enable = false;
  services.zerotierone.enable = true;
  services.mongodb.enable = false;
  services.redis.enable = false;

  services.xserver.libinput.enable = true;
  services.xserver.config = ''
    Section "InputClass"
      Identifier     "Enable libinput for TrackPoint"
      MatchProduct   "TPPS/2 Elan TrackPoint"
      Driver         "libinput"
      Option         "AccelSpeed" "1"
      Option         "AccelProfile" "flat"
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

  systemd.user.services.clightning-rpc-tunnel = {
    description = "clightning mainnet rpc tunnel";
    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    serviceConfig.ExecStart = extra.util.writeBash "lightning-tunnel" ''
      socket=/home/jb55/.lightning-bitcoin-rpc
      rm -f $socket
      ${pkgs.socat}/bin/socat -d -d UNIX-LISTEN:$socket,reuseaddr,fork TCP:10.147.20.220:7878
    '';
  };

  systemd.user.services.clightning-testnet-rpc-tunnel = {
    description = "clightning testnet rpc tunnel";
    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    serviceConfig.ExecStart = extra.util.writeBash "lightning-testnet-tunnel" ''
      socket=/home/jb55/.lightning-testnet-rpc
      rm -f $socket
      ${pkgs.socat}/bin/socat -d -d UNIX-LISTEN:$socket,reuseaddr,fork TCP:10.147.20.220:7879
    '';
  };

  services.hydra.enable = false;
  services.hydra.dbi = "dbi:Pg:dbname=hydra;host=localhost;user=postgres;";
  services.hydra.hydraURL = "localhost";
  services.hydra.notificationSender = "hydra@quiver";
  services.hydra.buildMachinesFiles = [];
  services.hydra.useSubstitutes = true;

  users.extraGroups.hydra.members = [ "jb55" ];
  users.extraGroups.www-data.members = [ "jb55" ];

  # https://github.com/nmikhailov/Validity90  # driver not done yet
  services.fprintd.enable = false;

  services.autorandr.enable = true;
  services.acpid.enable = false;
  powerManagement.enable = false;

  networking.wireless.enable = true;

  programs.gnupg.trezor-agent = {
    enable = true;
    configPath = "/home/jb55/.gnupg/trezor";
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/10/";
    enable = true;
    package = pkgs.postgresql_10;
    # extraPlugins = with pkgs; [ pgmp ];
    authentication = pkgs.lib.mkForce ''
      # type db  user address            method
      local  all all                     trust
      host   all all  localhost          trust
    '';
    # extraConfig = ''
    #   listen_addresses = '172.24.172.226,127.0.0.1'
    # '';
  };

}
