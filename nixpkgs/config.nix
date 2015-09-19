{ 
  allowUnfree = true;
  allowUnfreeRedistributable = true;
  obs-studio.pulseaudio = true;
  steam.java = true;
  allowBroken = false;
  zathura.useMupdf = true;

  chromium = {
    enablePepperFlash = true;
    enablePepperPDF = true;
  };

  packageOverrides = super: let pkgs = super.pkgs; in
  rec {
    haskellEnv = pkgs.buildEnv {
      paths = with pkgs.haskellPackages; [
        (ghcWithHoogle myHaskellPackages)
        cabal2nix
        hindent
        hlint
        #ghc-mod
        #hdevtools
        ghc-core
        structured-haskell-mode
        hasktags
        pointfree
        cabal-install
        alex happy
      ];
    };

    syntaxCheckersEnv = self.buildEnv {
      name = "syntaxCheckers";
      paths = with self; [
        haskellPackages.ShellCheck
      ];
    };

    machineLearningToolsEnv = self.buildEnv {
      name = "machineLearningTools";
      paths = with self; [
        caffe
      ];
    };

    myHaskellPackages = hp: with hp; [
      # fixplate
      # orgmode-parse
      Boolean
      # CC-delcont
      HTTP
      HUnit
      MissingH
      QuickCheck
      aeson
      # arithmoi
      async
      attoparsec
      bifunctors
      blaze-builder
      blaze-builder-conduit
      blaze-builder-enumerator
      blaze-html
      blaze-markup
      blaze-textual
      cased
      cereal
      comonad
      comonad-transformers
      # compdata
      dlist
      dlist-instances
      doctest
      # errors
      exceptions
      fingertree
      foldl
      folds
      free
      hamlet
      hashable
      hspec
      hspec-expectations
      html
      http-client
      http-date
      http-types
      io-memoize
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
      # linearscan
      # linearscan-hoopl
      list-extras
      list-t
      logict
      # machines
      mime-mail
      mime-types
      mmorph
      monad-control
      monad-coroutine
      monad-loops
      monad-par
      monad-par-extras
      monad-stm
      monadloc
      monoid-extras
      network
      newtype
      numbers
      optparse-applicative
      # pandoc
      parsec
      parsers
      pipes
      pipes-attoparsec
      pipes-binary
      pipes-bytestring
      pipes-concurrency
      pipes-csv
      pipes-mongodb
      pipes-extras
      pipes-group
      pipes-http
      pipes-network
      pipes-parse
      pipes-safe
      pipes-shell
      pipes-text
      posix-paths
      #postgresql-simple
      pretty-show
      profunctors
      random
      # recursion-schemes
      reducers
      reflection
      regex-applicative
      regex-base
      regex-compat
      regex-posix
      regular
      resourcet
      retry
      rex
      SafeSemaphore
      safe
      sbv
      scotty
      semigroupoids
      semigroups
      shake
      shakespeare
      shelly
      simple-reflect
      # singletons
      speculation
      split
      spoon
      stm
      stm-chans
      stm-stats
      streaming
      streaming-bytestring
      strict
      stringsearch
      strptime
      syb
      system-fileio
      system-filepath
      tagged
      tar
      tardis
      tasty
      tasty-hspec
      tasty-hunit
      tasty-quickcheck
      tasty-smallcheck
      temporary
      text
      text-format
      # these
      # thyme
      time
      # time-recurrence
      # timeparsers
      transformers
      transformers-base
      turtle
      uniplate
      # units
      unix-compat
      unordered-containers
      uuid
      vector
      void
      wai
      warp
      xhtml
      yaml
      zippers
      zlib
    ];

    xlsx2csv = super.pythonPackages.buildPythonPackage rec {
      name = "xlsx2csv-0.7.2";
      src = self.pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/x/xlsx2csv/${name}.tar.gz";
        md5 = "eea39d8ab08ff4503bb145171d0a46f6";
      };
      meta = {
        homepage = https://github.com/bitprophet/alabaster;
        description = "xlsx2csv converter";
        license = self.stdenv.lib.licenses.bsd3;
      };
    };
  };
}
