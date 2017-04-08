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
    bluez = pkgs.bluez5;

    # qt4 = pkgs.qt48Full.override { gtkStyle = true; };

    haskellPackages = super.haskellPackages.override {
      overrides = haskellOverrides pkgs;
    };

    pidgin-with-plugins = super.pidgin-with-plugins.override {
      plugins = (with super; [ purple-hangouts pidginotr pidginwindowmerge pidgin-skypeweb pidgin-opensteamworks ]);
    };

    jb55-dotfiles = regularFiles <dotfiles>;

    ical2org = super.callPackage ./scripts/ical2org { };

    footswitch = super.callPackage ./scripts/footswitch { };

    ds4ctl = super.callPackage ./scripts/ds4ctl { };

    haskellEnvHoogle = haskellEnvFun {
      name = "haskellEnvHoogle";
      withHoogle = true;
    };

    haskellEnv = haskellEnvFun {
      name = "haskellEnv";
      withHoogle = false;
    };

    haskell-tools-env = super.buildEnv {
      name = "haskell-tools";
      paths = haskellTools haskellPackages;
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

    gaming-env = pkgs.buildEnv {
      name = "gaming";
      paths = with pkgs; [
        steam
      ];
    };

    git-tools-env = pkgs.buildEnv {
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
                 else haskellPackages;

          ghcWith = if withHoogle
                      then hp.ghcWithHoogle
                      else hp.ghcWithPackages;

      in super.buildEnv {
        name = name;
        paths = [(ghcWith myHaskellPackages)];
      };

    haskellTools = hp: with hp; [
      #ghc-mod
      #hdevtools
      # binary-serialise-cbor
      alex
      cabal-install
      cabal2nix
      ghc-core
      ghc-mod
      happy
      hasktags
      hindent
      hlint
      # pointfree
      structured-haskell-mode
      super.multi-ghc-travis
    ];

    myHaskellPackages = hp: with hp; [
      aeson
      # aeson-applicative
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
      # blaze-builder-enumerator
      blaze-html
      blaze-markup
      blaze-textual
      Boolean
      # bound
      bson-lens
      cased
      cassava
      cereal
      comonad
      comonad-transformers
      compact-string-fix
      directory
      dlist
      dlist-instances
      doctest
      either
      elm-export
      # envy
      exceptions
      failure
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
      gtk
      hamlet
      hashable
      heroku
      hspec
      hspec-expectations
      html
      HTTP
      http-client
      http-date
      http-types
      HUnit
      io-memoize
      keys
      # language-bash
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
      MissingH
      mmorph
      monad-control
      monad-coroutine
      monadloc
      monad-loops
      monad-par
      monad-par-extras
      monad-stm
      mongoDB
      monoid-extras
      # monstercat-backend
      network
      newtype
      numbers
      options
      optparse-applicative
      parsec
      parsers
      pcg-random
      persistent
      #persistent-mongoDB
      persistent-postgresql
      persistent-template
      pipes
      # pipes-async
      pipes-attoparsec
      # pipes-binary
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
      # pipes-shell
      pipes-text
      pipes-wai
      posix-paths
      postgresql-binary
      postgresql-simple
      # postgresql-simple-sop
      pretty-show
      profunctors
      QuickCheck
      random
      reducers
      reflection
      regex-applicative
      regex-base
      regex-compat
      regex-posix
      # regular
      relational-record
      resourcet
      retry
      rex
      safe
      SafeSemaphore
      sbv
      scotty
      semigroupoids
      semigroups
      servant
      servant-cassava
      servant-client
      servant-docs
      # servant-elm
      servant-lucid
      servant-server
      # servant-swagger
      shake
      shakespeare
      shelly
      simple-reflect
      speculation
      split
      Spock
      spoon
      stm
      stm-chans
      stm-stats
      streaming
      streaming-bytestring
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
      time
      # time-patterns
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
