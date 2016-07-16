{ config, lib, pkgs, ... }:
{
  services.zerotierone.enable = true;

  services.mongodb.enable = true;
  services.redis.enable = true;
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.authorizedKeys = ''
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAvMdnEEAd/ZQM+pYp6ZYG/1NPE/HSwIKoec0/QgGy4UlO0EvpWWhxPaV0HlNUFfwiHE0I2TwHc+KOKcG9jcbLAjCk5rvqU7K8UeZ0v/J83bQh78dr4le09WLyhczamJN0EkNddpCyUqIbH0q3ISGPmTiW4oQniejtkdJPn2bBwb3Za8jLzlh2UZ/ZJXhKvcGjQ/M1+fBmFUwCp5Lpvg0XYXrmp9mxAaO+fxY32EGItXcjYM41xr/gAcpmzL5rNQ9a9YBYFn2VzlpL+H7319tgdZa4L57S49FPQ748paTPDDqUzHtQD5FEZXe7DZZPZViRsPc370km/5yIgsEhMPKr jb55
  '';

  services.logrotate = {
    enable = true;
    config = ''
      dateext
      dateformat %Y-%m-%d.
      compresscmd ${pkgs.xz.bin}/bin/xz
      uncompresscmd ${pkgs.xz.bin}/bin/unxz
      compressext .xz
    '';
  };
}
