{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
    ./nginx
  ];

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = true;
    authentication = ''
      # type db  user address        method
      local  all all                 trust
      host   all all  127.0.0.1/32   trust
      host   all all  172.24.0.0/16  trust
    '';
    extraConfig = ''
      listen_addresses = '0.0.0.0'
    '';
  };

  systemd.services.postgrest = {
    description = "PostgREST";

    wantedBy = [ "multi-user.target" ];
    after    = [ "postgresql.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = ''
      ${pkgs.haskellPackages.postgrest}/bin/postgrest \
        'postgres://localhost/wineparty' \
        -a jb55
    '';
  };

  systemd.services.weechat = {
    description = "Weechat relay server";

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = "yes";
    serviceConfig.ExecStart = pkgs.writeScript "weechat-service" ''
      #!${pkgs.bash}/bin/bash
      set -e
      ${pkgs.rsync}/bin/rsync -rlD ${pkgs.jb55-dotfiles}/.weechat/ /tmp/weechat/
      ${pkgs.tmux.bin}/bin/tmux -S /run/tmux-weechat new-session -d -s weechat -n 'weechat' '${pkgs.weechat}/bin/weechat-curses -d /tmp/weechat'
    '';
    serviceConfig.ExecStop = "${pkgs.tmux.bin}/bin/tmux -S /run/tmux-weechat kill-session -t weechat";

  };

  systemd.services.weechat.enable = true;
  systemd.services.postgrest.enable = true;
}
