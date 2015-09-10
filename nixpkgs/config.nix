{ allowUnfree = true;
  allowUnfreeRedistributable = true;
  obs-studio.pulseaudio = true;
  steam.java = true;
  allowBroken = false;

  chromium = {
    enablePepperFlash = true;
    enablePepperPDF = true;
  };

  packageOverrides = super: let self = super.pkgs; in
  {
    haskellDevToolsEnv = self.buildEnv {
      name = "haskellDevTools";
      paths = with self.haskellPackages; [
        cabal2nix
        hindent
        hlint
        ghc-mod
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
