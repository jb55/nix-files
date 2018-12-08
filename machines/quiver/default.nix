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

   services.bitcoind.networks = {
     testnet = {
       testnet = true;
       dataDir = "/var/lib/bitcoin-testnet";
       prune = 1000;
       extraConfig = ''
         rpcuser=rpcuser
         rpcpassword=rpcpass
       '';
     };

     mainnet = {
       dataDir = "/var/lib/bitcoin";
       prune = 1000;
       extraConfig = ''
         rpcuser=rpcuser
         rpcpassword=rpcpass
       '';
     };
   };

   services.clightning.networks = {
     testnet = {
       dataDir = "/home/jb55/.lightning";

       config = ''
         fee-per-satoshi=9000
         bitcoin-rpcuser=rpcuser
         bitcoin-rpcpassword=rpcpass
         network=testnet
         log-level=debug
         alias=@jb55
         rgb=ff0000
       '';
     };

     # mainnet = {
     #   dataDir = "/home/jb55/.lightning-bitcoin";

     #   config = ''
     #     bitcoin-rpcuser=rpcuser
     #     bitcoin-rpcpassword=rpcpassword
     #     fee-per-satoshi=9000
     #     network=bitcoin
     #     log-level=debug
     #     alias=@jb55
     #     rgb=ff0000
     #   '';
     # };
   };



  users.extraGroups.www-data.members = [ "jb55" ];

  # https://github.com/nmikhailov/Validity90  # driver not done yet
  services.fprintd.enable = false;

  services.autorandr.enable = true;
  services.acpid.enable = false;
  powerManagement.enable = false;

  networking.wireless.enable = true;

  programs.gnupg.trezor-agent = {
    enable = false;
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
