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

  virtualisation.docker.enable = true;

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
      MatchProduct   "PS/2 Generic Mouse"
      Driver         "libinput"
      Option         "ScrollMethod" "button"
      Option         "ScrollButton" "8"
      Option         "AccelSpeed" "1"
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

  services.nginx.enable = false;

  services.nginx.httpConfig = lib.mkIf config.services.plex.enable ''
    server {
      listen 80;

      # server names for this server.
      # any requests that come in that match any these names will use the proxy.
      server_name plex.jb55.com;

      # this is where everything cool happens (you probably don't need to change anything here):
      location / {
        # if a request to / comes in, 301 redirect to the main plex page.
        # but only if it doesn't contain the X-Plex-Device-Name header
        # this fixes a bug where you get permission issues when accessing the web dashboard

        if ($http_x_plex_device_name = \'\') {
          rewrite ^/$ http://$http_host/web/index.html;
        }

        # set some headers and proxy stuff.
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_redirect off;

        # include Host header
        proxy_set_header Host $http_host;

        # proxy request to plex server
        proxy_pass http://127.0.0.1:32400;
      }
    }
  '';


  # https://github.com/nmikhailov/Validity90  # driver not done yet
  services.fprintd.enable = false;

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
