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
  };

  systemd.services.postgrest = {
    description = "PostgREST";

    wantedBy = [ "multi-user.target" ];
    after = [ "postgresql.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = ''
      ${pkgs.haskellPackages.postgrest}/bin/postgrest \
        'postgres://localhost/wineparty' \
        -a jb55
    '';
  };

  # from https://github.com/garbas/dotfiles/blob/b76677b9f3fb43e8d40f4872d327bee93c720f3e/nixops/floki.nix#L236
  # thanks @garbas
  systemd.services.weechat = with pkgs; {
    enable = true;
    description = "Weechat IRC Client (in tmux)";
    environment = { TERM = "${rxvt_unicode.terminfo}"; };
    path = [ tmux weechat rxvt_unicode.terminfo which ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${tmux}/bin/tmux -S /run/tmux-weechat new-session -d -s weechat -n 'weechat' '${weechat}/bin/weechat-curses -d ${jb55-dotfiles}/.weechat'";
      ExecStop = "${tmux}/bin/tmux -S /run/tmux-weechat kill-session -t weechat";
    };
  };

  systemd.services.postgrest.enable = true;
}
