
{ extra, config, pkgs }:
let gitwebConf = pkgs.writeText "gitweb.conf" ''
      # path to git projects (<project>.git)
      $projectroot = "${extra.git.projectroot}";
    '';
    gitweb-wrapper = pkgs.writeScript "gitweb.cgi" ''
      #!${pkgs.bash}/bin/bash
      export PERL5LIB=$PERL5LIB:${with pkgs.perlPackages; pkgs.lib.makePerlPath [ CGI HTMLParser ]}
      ${pkgs.perl}/bin/perl ${pkgs.git}/share/gitweb/gitweb.cgi
    '';
    gitweb-theme = pkgs.fetchFromGitHub {
      owner  = "kogakure";
      repo   = "gitweb-theme";
      rev    = "4305b3551551c470339c24a6567b1ac9e642ae54";
      sha256 = "0gagy0jvqb3mc587b6yy8l9g5j5wqr2xlz128v6f01364cb7whmv";
    };
    giturl = "git.monster.cat";
in
if config.services.fcgiwrap.enable then ''
  server {
      listen       80;
      server_name  ${giturl};

      location = / {
        return 301 http://${giturl}/repos/;
      }

      location = /repos {
        return 301 http://${giturl}/repos/;
      }

      location / {
        # fcgiwrap is set up to listen on this host:port
        fastcgi_pass                  unix:${config.services.fcgiwrap.socketAddress};
        include                       ${pkgs.nginx}/conf/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME ${pkgs.git}/bin/git-http-backend;

        client_max_body_size 0;

        # export all repositories under GIT_PROJECT_ROOT

        fastcgi_param GIT_HTTP_EXPORT_ALL "";
        fastcgi_param GIT_PROJECT_ROOT    ${extra.git.projectroot};
        fastcgi_param PATH_INFO           $uri;
      }

      location /repos/static {
        alias ${gitweb-theme};
      }

      location /add-repo {
        include ${pkgs.nginx}/conf/fastcgi_params;
        gzip off;

        fastcgi_param SCRIPT_FILENAME /var/git/mkrepod;
        fastcgi_pass  unix:${config.services.fcgiwrap.socketAddress};
      }

      location /repos {
        include ${pkgs.nginx}/conf/fastcgi_params;
        gzip off;

        fastcgi_param GITWEB_CONFIG   ${gitwebConf};
        fastcgi_param SCRIPT_FILENAME ${gitweb-wrapper};
        fastcgi_pass  unix:${config.services.fcgiwrap.socketAddress};
      }

  }
'' else ""
