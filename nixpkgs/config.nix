{ pkgs }:
let monstercatPkgs = import <monstercatpkgs> { inherit pkgs; };
    haskellOverrides = import ./haskell-overrides { inherit monstercatPkgs; };
    jb55pkgs = import <jb55pkgs> { nixpkgs = pkgs; };
    callPackage = pkgs.callPackage;
    regularFiles = builtins.filterSource (f: type: type == "symlink"
                                                || type == "directory"
                                                || type == "regular");
in {
  allowUnfree = true;
  allowUnfreeRedistributable = true;
  allowBroken = false;
  zathura.useMupdf = true;

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  chromium = {
    enablePepperFlash = false; # Chromium's non-NSAPI alternative to Adobe Flash
    enablePepperPDF = false;
  };

  packageOverrides = super: rec {
    # /run/current-system/sw/bin/ls $HOME/.emacs.d/elpa | sed 's/-[[:digit:]].*//g;s/\+$/-plus/g' | sort -u
    emacs = super.emacsWithPackages (ep: with ep; [
      pkgs.urweb
    ]);

    bluez = pkgs.bluez5;

    # qt4 = pkgs.qt48Full.override { gtkStyle = true; };

    #haskellPackages = super.haskell.packages.ghc821;

    clipmenu = super.callPackage ./clipmenu {};

    pidgin-with-plugins = super.pidgin-with-plugins.override {
      plugins = (with super; [
        purple-hangouts
        pidginotr
        pidginwindowmerge
        pidgin-skypeweb
        pidgin-opensteamworks
        pidgin-carbons
      ]);
    };

    jb55-dotfiles = regularFiles <dotfiles>;

    notmuch = pkgs.lib.overrideDerivation super.notmuch (attrs: {
      src = pkgs.fetchFromGitHub {
        owner  = "jb55";
        repo   = "notmuch";
        rev    = "cae2d57dbc1fd94d7f3c7935da6e15765d60da70";
        sha256 = "0lngrnzlaz17y9ngcjzj63br59f8zz5npbx26nrwmmk81zvbwl5m";
      };

      doCheck = false;
    });

    dmenu2 = pkgs.lib.overrideDerivation super.dmenu2 (attrs: {
      patches = [ (super.fetchurl { url = "https://jb55.com/s/404ad3952cc5ccf3.patch";
                                    sha1 = "404ad3952cc5ccf3aa0674f31a70ef0e446a8d49";
                                  })
                ];
    });

    ical2org = super.callPackage ./scripts/ical2org { };

    footswitch = super.callPackage ./scripts/footswitch { };

    ds4ctl = super.callPackage ./scripts/ds4ctl { };

    haskellEnvHoogle = haskellEnvFun {
      name = "haskellEnvHoogle";
      #compiler = "ghc821";
      withHoogle = true;
    };

    haskellEnv = haskellEnvFun {
      name = "haskellEnv";
      #compiler = "ghc821";
      withHoogle = false;
    };

    haskell-tools = super.buildEnv {
      name = "haskell-tools";
      paths = haskellTools super.haskellPackages;
    };

    jb55-tools-env = pkgs.buildEnv {
      name = "jb55-tools";
      paths = with jb55pkgs; [
        csv-delim
        csv-scripts
        dbopen
        extname
        mandown
        snap
        sharefile
        samp
      ];
    };

    jvm-tools-env = pkgs.buildEnv {
      name = "jvm-tools";
      paths = with pkgs; [
        gradle
        maven
        oraclejdk
      ];
    };

    mk-rust-env = name: rustVer: pkgs.buildEnv {
      name = "rust-dev-${name}";
      paths = with pkgs; with rustVer; [
        clang
        rustracer
        rustracerd
        rust
        cargo-edit
        rustfmt
        rust-bindgen
      ];
    };

    rust-dev-env-nightly = mk-rust-env "nightly" pkgs.rustChannels.nightly;
    rust-dev-env-beta = mk-rust-env "beta" pkgs.rustChannels.beta;

    gaming-env = pkgs.buildEnv {
      name = "gaming";
      paths = with pkgs; [
        steam
      ];
    };

    file-tools = pkgs.buildEnv {
      name = "file-tools";
      paths = with pkgs; [
        ripgrep
        ranger
      ];
    };

    network-tools = pkgs.buildEnv {
      name = "network-tools";
      paths = with pkgs; with xorg; [
        nmap
        dnsutils
        whois
        nethogs
      ];
    };

    system-tools = pkgs.buildEnv {
      name = "system-tools";
      paths = with pkgs; with xorg; [
        xbacklight
        acpi
        psmisc
      ];
    };

    desktop-tools = pkgs.buildEnv {
      name = "desktop-tools";
      paths = with pkgs; with xorg; [
        twmn
        libnotify
      ];
    };

    syntax-tools = pkgs.buildEnv {
      name = "syntax-tools";
      paths = with pkgs; [
        shellcheck
      ];
    };

    mail-tools = pkgs.buildEnv {
      name = "mail-tools";
      paths = with pkgs; [
        notmuch
        msmtp
        muchsync
        isync
      ];
    };

    git-tools = pkgs.buildEnv {
      name = "git-tools";
      paths = with pkgs; [
        diffstat
        diffutils
        gist
        # git-lfs
        gitAndTools.diff-so-fancy
        gitAndTools.git-imerge
        gitAndTools.git-extras
        gitAndTools.gitFull
        gitAndTools.hub
        gitAndTools.tig
        #haskPkgs.git-all
        #haskPkgs.git-monitor
        github-release
        patch
        patchutils
      ];
    };

    haskellEnvFun = { withHoogle ? false, compiler ? null, name }:
      let hp = if compiler != null
                 then super.haskell.packages.${compiler}
                 else super.haskellPackages;

          ghcWith = if withHoogle
                      then hp.ghcWithHoogle
                      else hp.ghcWithPackages;

      in super.buildEnv {
        name = name;
        paths = [(ghcWith myHaskellPackages)];
      };

    haskellTools = hp: with hp; [
      alex
      cabal-install
      cabal2nix
      ghc-core
      happy
      hasktags
      hindent
      hlint
      structured-haskell-mode
      #multi-ghc-travis
    ];

    myHaskellPackages = hp: with hp; [
      # aeson-applicative
      # blaze-builder-enumerator
      # bound
      # envy
      # language-bash
      # monstercat-backend
      # pipes-async
      # pipes-binary
      # pipes-shell
      # postgresql-simple-sop
      # regular
      # servant-swagger
      # time-patterns
      #failure
      #persistent-mongoDB
      #servant-auth-server
      Boolean
      Decimal
      HTTP
      HUnit
      MissingH
      QuickCheck
      quickcheck-instances
      SafeSemaphore
      Spock
      aeson
      aeson-qq
      amazonka
      amazonka-s3
      async
      attoparsec
      bifunctors
      bitcoin-api
      bitcoin-api-extra
      bitcoin-block
      bitcoin-script
      bitcoin-tx
      blaze-builder
      blaze-builder-conduit
      blaze-html
      blaze-markup
      blaze-textual
      bson-lens
      cryptohash
      cased
      cassava
      cereal
      clientsession
      clientsession
      colour
      comonad
      comonad-transformers
      compact-string-fix
      diagrams
      directory
      dlist
      dlist-instances
      doctest
      either
      elm-export
      elm-export-persistent
      exceptions
      filepath
      fingertree
      foldl
      formatting
      free
      generics-sop
      gogol
      gogol-core
      gogol-sheets
      gogol-youtube
      gogol-youtube-reporting
      hamlet
      hashable
      hashids
      heroku
      hspec
      hspec-expectations
      html
      http-client
      http-date
      http-types
      io-memoize
      io-storage
      keys
      language-c
      language-javascript
      lens
      lens-action
      lens-aeson
      lens-datetime
      lens-family
      lens-family-core
      lifted-async
      lifted-base
      linear
      list-extras
      list-t
      logict
      mime-mail
      mime-types
      miso
      mmorph
      monad-control
      monad-coroutine
      monad-loops
      monad-par
      monad-par-extras
      monad-stm
      monadloc
      mongoDB
      monoid-extras
      neat-interpolation
      network
      newtype
      numbers
      options
      optparse-applicative
      optparse-generic
      parsec
      parsers
      pcg-random
      persistent
      persistent-postgresql
      persistent-template
      pipes
      pipes-attoparsec
      pipes-bytestring
      pipes-concurrency
      pipes-csv
      pipes-extras
      pipes-group
      pipes-http
      pipes-mongodb
      pipes-network
      pipes-parse
      pipes-postgresql-simple
      pipes-safe
      pipes-text
      pipes-wai
      posix-paths
      postgresql-binary
      postgresql-simple
      pretty-show
      probability
      profunctors
      pwstore-fast
      random
      reducers
      reflection
      regex-applicative
      regex-base
      regex-compat
      regex-posix
      relational-record
      resourcet
      retry
      rex
      s3-signer
      safe
      sbv
      scotty
      semigroupoids
      semigroups
      servant
      servant-cassava
      servant-client
      servant-docs
      servant-elm
      servant-lucid
      servant-server
      shake
      shakespeare
      shelly
      shqq
      simple-reflect
      speculation
      split
      spoon
      stm
      stm-chans
      stm-stats
      streaming
      streaming-bytestring
      streaming-postgresql-simple
      streaming-utils
      streaming-wai
      strict
      stringsearch
      strptime
      syb
      system-fileio
      system-filepath
      tagged
      taggy
      taggy-lens
      tar
      tardis
      tasty
      tasty-hspec
      tasty-hunit
      tasty-quickcheck
      tasty-smallcheck
      temporary
      test-framework
      test-framework-hunit
      text
      text-format
      thyme
      time
      time-units
      tinytemplate
      transformers
      transformers-base
      turtle
      uniplate
      unix-compat
      unordered-containers
      uuid
      vector
      void
      wai
      warp
      wreq
      xhtml
      xml-lens
      yaml
      zippers
      zlib
    ];
  };
}
