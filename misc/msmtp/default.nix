extra:
{ config, lib, pkgs, ... }:
{
  # services.mail.sendmailSetuidWrapper = {
  #   program = "sendmail";
  #   source = lib.mkForce (extra.util.writeBash "sendmail" ''
  #     ${pkgs.msmtp}/bin/msmtp --read-envelope-from -C /home/jb55/.msmtprc -t "$@"
  #   '');
  #   setuid = false;
  #   setgid = false;
  # };
}
