
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mailz;
  mailbox = name: ''
    mailbox ${name} {
      auto = subscribe
    }
  '';

  # Convert:
  #
  #   {
  #     a = { aliases = [ "x", "y" ]; };
  #     b = { aliases = [ "x" ]; };
  #   }
  #
  # To:
  #
  #   {
  #     x = [ "a" "b" ];
  #     y = [ "a" ];
  #   }
  aliases = foldAttrs (user: users: [user] ++ users) [ ]
    (flatten (flip mapAttrsToList cfg.users
      (user: options: flip map options.aliases
        (alias: { ${alias} = user; }))));

  files = {
    credentials = pkgs.writeText "credentials"
      (concatStringsSep "\n"
        (flip mapAttrsToList cfg.users
          (user: options: "${user}@${cfg.domain} ${options.password}")));

    users = pkgs.writeText "users"
      (concatStringsSep "\n"
        (flip mapAttrsToList cfg.users
          (user: options: "${user}:${options.password}:::::")));

    recipients = pkgs.writeText "recipients"
      (concatStringsSep "\n"
        (map (user: "${user}@${cfg.domain}")
          (attrNames cfg.users ++ flatten ((flip mapAttrsToList) cfg.users
            (user: options: options.aliases)))));

    aliases = pkgs.writeText "aliases"
      (concatStringsSep "\n"
        (flip mapAttrsToList aliases
          (alias: users: "${alias} ${concatStringsSep "," users}")));

    spamassassinSieve = pkgs.writeText "spamassassin.sieve" ''
      require "fileinto";
      if header :contains "X-Spam-Flag" "YES" {
        fileinto "Spam";
      }
    '';

    # From <https://github.com/OpenSMTPD/OpenSMTPD-extras/blob/master/extras/wip/filters/filter-regex/filter-regex.conf>
    regex = pkgs.writeText "filter-regex.conf" ''
      helo ! ^\[
      helo ^\.
      helo \.$
      helo ^[^\.]*$
    '';
  };

in

{
  options = {
    services.mailz = {
      domain = mkOption {
        default = cfg.networking.hostName;
        type = types.str;
        description = "Domain for this mail server.";
      };

      enable = mkEnableOption "enable mailz: self-hosted email";

      user = mkOption {
        default = "vmail";
        type = types.str;
      };

      sieves = mkOption {
        default = "";
        type = types.str;
      };

      group = mkOption {
        default = "vmail";
        type = types.str;
      };

      uid = mkOption {
        default = 2000;
        type = types.int;
      };

      gid = mkOption {
        default = 2000;
        type = types.int;
      };

      dkimDirectory = mkOption {
        default = "/var/lib/dkim";
        type = types.str;
        description = "Where to store DKIM keys.";
      };

      dkimBits = mkOption {
        type = types.int;
        default = 2048;
        description = "Size of the generated DKIM key.";
      };

      users = mkOption {
        default = { };
        type = types.loaOf types.optionSet;
        description = ''
          Attribute set of users.
        '';

        options = {
          password = mkOption {
            type = types.str;
            description = ''
              The user password, generated with
              <literal>smtpctl encrypt</literal>.
            '';
          };

          aliases = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "postmaster" ];
            description = "A list of aliases for this user.";
          };
        };

        example = {
          "foo" = {
            password = "encrypted";
            aliases = [ "postmaster" ];
          };
          "bar" = {
            password = "encrypted";
          };
        };
      };
    };
  };

  config = mkIf (cfg.enable && cfg.users != { }) {
    nixpkgs.config.packageOverrides = pkgs: {
      opensmtpd = pkgs.callPackage ./opensmtpd.nix { };
      opensmtpd-extras = pkgs.opensmtpd-extras.override {
        # Needed to have PRNG working in chroot (for dkim-signer)
        openssl = pkgs.libressl;
      };
    };

    system.activationScripts.mailz = ''
      # Make sure SpamAssassin database is present
      if ! [ -d /etc/spamassassin ]; then
        cp -r ${pkgs.spamassassin}/share/spamassassin /etc
      fi

      # Make sure a DKIM private key exist
      if ! [ -d ${cfg.dkimDirectory}/${cfg.domain} ]; then
        mkdir -p ${cfg.dkimDirectory}/${cfg.domain}
        chmod 700 ${cfg.dkimDirectory}/${cfg.domain}
        ${pkgs.opendkim}/bin/opendkim-genkey --bits ${toString cfg.dkimBits} --domain ${cfg.domain} --directory ${cfg.dkimDirectory}/${cfg.domain}
      fi
    '';

    services.spamassassin.enable = true;

    services.opensmtpd = {
      enable = true;
      serverConfiguration = ''
        filter filter-pause pause
        filter filter-regex regex "${files.regex}"
        filter filter-spamassassin spamassassin "-s accept"
        filter filter-dkim-signer dkim-signer "-d ${cfg.domain}" "-p${cfg.dkimDirectory}/${cfg.domain}/default.private"
        filter in chain filter-regex filter-spamassassin
        filter out chain filter-dkim-signer

        pki ${cfg.domain} certificate "/var/lib/acme/${cfg.domain}/fullchain.pem"
        pki ${cfg.domain} key "/var/lib/acme/${cfg.domain}/key.pem"

        table credentials file:${files.credentials}
        table recipients file:${files.recipients}
        table aliases file:${files.aliases}

        listen on 0.0.0.0 port 25 hostname ${cfg.domain} filter in tls pki ${cfg.domain}
        listen on 0.0.0.0 port 12566 hostname ${cfg.domain} filter out tls-require pki ${cfg.domain} auth <credentials>

        accept from any for domain "${cfg.domain}" recipient <recipients> alias <aliases> deliver to lmtp localhost:24
        accept from local for any relay
      '';
      procPackages = [ pkgs.opensmtpd-extras ];
    };

    services.dovecot2 = {
      enable = true;
      enablePop3 = false;
      enableLmtp = true;
      mailLocation = "maildir:/var/spool/mail/%n";
      mailUser = cfg.user;
      mailGroup = cfg.group;
      modules = [ pkgs.dovecot_pigeonhole ];
      sslServerCert = "/var/lib/acme/${cfg.domain}/fullchain.pem";
      sslServerKey = "/var/lib/acme/${cfg.domain}/key.pem";
      enablePAM = false;
      sieveScripts = {
        before = files.spamassassinSieve;
        before2 = pkgs.writeText "sieves" cfg.sieves;
      };
      extraConfig = ''
        postmaster_address = postmaster@${cfg.domain}
        mail_attribute_dict = file:/var/spool/mail/%n/dovecot-attributes

        service lmtp {
          inet_listener lmtp {
            address = 127.0.0.1 ::1
            port = 24
          }
        }

        service imap-login {
          inet_listener imaps {
            port = 12788
            ssl = yes
          }
        }

        userdb {
          driver = passwd-file
          args = username_format=%n ${files.users}
          default_fields = uid=${cfg.user} gid=${cfg.user} home=/var/spool/mail/%n
        }

        passdb {
          driver = passwd-file
          args = username_format=%n ${files.users}
        }

        namespace inbox {
          inbox = yes

          mailbox Sent {
              auto = subscribe
              special_use = \Sent
          }

          mailbox Drafts {
              auto = subscribe
              special_use = \Drafts
          }

          mailbox Spam {
              auto = subscribe
              special_use = \Junk
          }

          mailbox Trash {
              auto = subscribe
              special_use = \Trash
          }

          mailbox Archives {
              auto = subscribe
              special_use = \Archive
          }

          ${mailbox "Alerts"}
          ${mailbox "RSS"}
          ${mailbox "GitHub"}
          ${mailbox "Lists"}
          ${mailbox "YouTube"}
          ${mailbox "Lists.ats"}
          ${mailbox "Arxiv"}
          ${mailbox "Reddit"}
          ${mailbox "Lists.lobsters"}
          ${mailbox "Lists.icn"}
          ${mailbox "HackerNews"}
          ${mailbox "Lists.craigslist"}
          ${mailbox "Lists.bitcoin"}
          ${mailbox "Lists.elm"}
          ${mailbox "Lists.emacs"}
          ${mailbox "Lists.guix"}
          ${mailbox "Lists.haskell"}
          ${mailbox "Lists.lkml"}
          ${mailbox "Lists.nix"}
          ${mailbox "Lists.nixpkgs"}
          ${mailbox "Lists.shen"}
          ${mailbox "Lists.spacemacs"}
          ${mailbox "Monstercat"}
          ${mailbox "Updates"}

        }

        protocol lmtp {
          mail_plugins = $mail_plugins sieve notify push_notification
        }

        protocol imap {
          imap_metadata = yes
        }
      '';
    };

    # users.extraUsers = optional (cfg.user == "vmail") {
    #   name = "vmail";
    #   uid = cfg.uid;
    #   group = cfg.group;
    # };

    # users.extraGroups = optional (cfg.group == "vmail") {
    #   name = "vmail";
    #   gid = cfg.gid;
    # };

    networking.firewall.allowedTCPPorts = [ 25 ];
  };
}
