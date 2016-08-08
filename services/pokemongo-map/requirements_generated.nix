# generated using pypi2nix tool (version: 1.3.0dev)
#
# COMMAND:
#   pypi2nix -V 2.7 -r requirements.txt -E stdenv -E sqlite
#

{ pkgs, python, commonBuildInputs ? [], commonDoCheck ? false }:

self: {

  "Babel" = python.mkDerivation {
    name = "Babel-2.3.4";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/6e/96/ba2a2462ed25ca0e651fb7b66e7080f5315f91425a07ea5b34d7c870c114/Babel-2.3.4.tar.gz";
      sha256= "c535c4403802f6eb38173cd4863e419e2274921a01a8aad8a5b497c131c62875";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."pytz"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Internationalization utilities";
    };
    passthru.top_level = false;
  };



  "CommonMark" = python.mkDerivation {
    name = "CommonMark-0.5.4";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/4d/93/3808cbcebe94d205f55a9a32857df733a603339d32c46cd32669d808d964/CommonMark-0.5.4.tar.gz";
      sha256= "34d73ec8085923c023930dfc0bcd1c4286e28a2a82de094bb72fabcc0281cbe5";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Python parser for the CommonMark Markdown spec";
    };
    passthru.top_level = false;
  };



  "ConfigArgParse" = python.mkDerivation {
    name = "ConfigArgParse-0.10.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/d0/b8/8f7689980caa66fc02671f5837dc761e4c7a47c6ca31b3e38b304cbc3e73/ConfigArgParse-0.10.0.tar.gz";
      sha256= "3b50a83dd58149dfcee98cb6565265d10b53e9c0a2bca7eeef7fb5f5524890a7";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "A drop-in replacement for argparse that allows options to also be set via config files and/or environment variables.";
    };
    passthru.top_level = false;
  };



  "Flask" = python.mkDerivation {
    name = "Flask-0.11.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/55/8a/78e165d30f0c8bb5d57c429a30ee5749825ed461ad6c959688872643ffb3/Flask-0.11.1.tar.gz";
      sha256= "b4713f2bfb9ebc2966b8a49903ae0d3984781d5c878591cf2f7b484d28756b0e";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."Jinja2"
      self."Werkzeug"
      self."click"
      self."itsdangerous"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "A microframework based on Werkzeug, Jinja2 and good intentions";
    };
    passthru.top_level = false;
  };



  "Flask-Compress" = python.mkDerivation {
    name = "Flask-Compress-1.3.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/4d/ce/44564d794ff7342ba376a92c88f8bb07f604d5d30f506bcde2834311eda8/Flask-Compress-1.3.0.tar.gz";
      sha256= "e6c52f1e56b59e8702aed6eb73c6fb0bffe942e5ca188f10e54a33ec11bc5ed4";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."Flask"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Compress responses in your Flask app with gzip.";
    };
    passthru.top_level = false;
  };



  "Flask-Cors" = python.mkDerivation {
    name = "Flask-Cors-2.1.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/99/c3/a65908bc5a031652248dfdb1fd4814391e7b8efca704a94008d764c45292/Flask-Cors-2.1.2.tar.gz";
      sha256= "f262e73adce557b2802a64054c82a0395576c88fbb944e3a9e1e2147140aa639";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."Flask"
      self."six"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "A Flask extension adding a decorator for CORS support";
    };
    passthru.top_level = false;
  };



  "Jinja2" = python.mkDerivation {
    name = "Jinja2-2.8";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz";
      sha256= "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."Babel"
      self."MarkupSafe"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "A small but fast and easy to use stand-alone template engine written in pure python.";
    };
    passthru.top_level = false;
  };



  "LatLon" = python.mkDerivation {
    name = "LatLon-1.0.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/4a/2c/ae890794253ce8f87b8d8d7fb49a99a61c007776c92fc9faf8f1febe3e31/LatLon-1.0.1.tar.gz";
      sha256= "0a5b3ba8f48b3bdf2f2c8f91ab4f80b1fa83d5cb5e3c28d5b16b4e3b3857f4fd";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."pyproj"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "";
      description = "Methods for representing geographic coordinates";
    };
    passthru.top_level = false;
  };



  "MarkupSafe" = python.mkDerivation {
    name = "MarkupSafe-0.23";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz";
      sha256= "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Implements a XML/HTML/XHTML Markup safe string for Python";
    };
    passthru.top_level = false;
  };



  "PyMySQL" = python.mkDerivation {
    name = "PyMySQL-0.7.5";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/f3/4c/9d7611b78e88d1f8087e24239c3318ccd973a822577508a69570382c9064/PyMySQL-0.7.5.tar.gz";
      sha256= "5006c7cf25cdf56f0c01ab21b8255ae5753464678c84ea8d00444667cc7a34ef";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Pure Python MySQL Driver";
    };
    passthru.top_level = false;
  };



  "PyYAML" = python.mkDerivation {
    name = "PyYAML-3.11";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz";
      sha256= "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "YAML parser and emitter for Python";
    };
    passthru.top_level = false;
  };



  "Pygments" = python.mkDerivation {
    name = "Pygments-2.1.3";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz";
      sha256= "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Pygments is a syntax highlighting package written in Python.";
    };
    passthru.top_level = false;
  };



  "Sphinx" = python.mkDerivation {
    name = "Sphinx-1.4.5";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/8b/78/eeea2b837f911cdc301f5f05163f9729a2381cadd03ccf35b25afe816c90/Sphinx-1.4.5.tar.gz";
      sha256= "c5df65d97a58365cbf4ea10212186a9a45d89c61ed2c071de6090cdf9ddb4028";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."Babel"
      self."Jinja2"
      self."Pygments"
      self."alabaster"
      self."docutils"
      self."imagesize"
      self."six"
      self."snowballstemmer"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Python documentation generator";
    };
    passthru.top_level = false;
  };



  "Werkzeug" = python.mkDerivation {
    name = "Werkzeug-0.11.10";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/b7/7f/44d3cfe5a12ba002b253f6985a4477edfa66da53787a2a838a40f6415263/Werkzeug-0.11.10.tar.gz";
      sha256= "cc64dafbacc716cdd42503cf6c44cb5a35576443d82f29f6829e5c49264aeeee";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "The Swiss Army knife of Python web development";
    };
    passthru.top_level = false;
  };



  "alabaster" = python.mkDerivation {
    name = "alabaster-0.7.9";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/71/c3/70da7d8ac18a4f4c502887bd2549e05745fa403e2cd9d06a8a9910a762bc/alabaster-0.7.9.tar.gz";
      sha256= "47afd43b08a4ecaa45e3496e139a193ce364571e7e10c6a87ca1a4c57eb7ea08";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "";
      description = "A configurable sidebar-enabled Sphinx theme";
    };
    passthru.top_level = false;
  };



  "argh" = python.mkDerivation {
    name = "argh-0.26.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/e3/75/1183b5d1663a66aebb2c184e0398724b624cecd4f4b679cb6e25de97ed15/argh-0.26.2.tar.gz";
      sha256= "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.lgpl3;
      description = "An unobtrusive argparse wrapper with natural syntax";
    };
    passthru.top_level = false;
  };



  "backports-abc" = python.mkDerivation {
    name = "backports-abc-0.4";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/f5/d0/1d02695c0dd4f0cf01a35c03087c22338a4f72e24e2865791ebdb7a45eac/backports_abc-0.4.tar.gz";
      sha256= "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "";
      description = "A backport of recent additions to the 'collections.abc' module.";
    };
    passthru.top_level = false;
  };



  "certifi" = python.mkDerivation {
    name = "certifi-2016.8.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/60/d8/e4dbd7239f1dd3854135949cc2cc8344602b1545a7929b7bf652ac69fbb6/certifi-2016.8.2.tar.gz";
      sha256= "65ddc34fd9c8509851031d7075b8325393b87e6dbe5875a723959a20266d7a41";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "ISC";
      description = "Python package for providing Mozilla's CA Bundle.";
    };
    passthru.top_level = false;
  };



  "click" = python.mkDerivation {
    name = "click-6.6";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz";
      sha256= "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "";
      description = "A simple wrapper around optparse for powerful command line utilities.";
    };
    passthru.top_level = false;
  };



  "docutils" = python.mkDerivation {
    name = "docutils-0.12";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/37/38/ceda70135b9144d84884ae2fc5886c6baac4edea39550f28bcd144c1234d/docutils-0.12.tar.gz";
      sha256= "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "public domain, Python, 2-Clause BSD, GPL 3 (see COPYING.txt)";
      description = "Docutils -- Python Documentation Utilities";
    };
    passthru.top_level = false;
  };



  "future" = python.mkDerivation {
    name = "future-0.15.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/5a/f4/99abde815842bc6e97d5a7806ad51236630da14ca2f3b1fce94c0bb94d3d/future-0.15.2.tar.gz";
      sha256= "3d3b193f20ca62ba7d8782589922878820d0a023b885882deec830adbf639b97";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Clean single-source support for Python 3 and 2";
    };
    passthru.top_level = false;
  };



  "geopy" = python.mkDerivation {
    name = "geopy-1.11.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/19/d0/7128146692fb6facb956b07c40f73d7975b9a36bd8381a0cdb0c6a79a0b6/geopy-1.11.0.tar.gz";
      sha256= "4250e5a9e9f7abb990eddf01d1491fc112755e14f76060011c607ba759a74112";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."pytz"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Python Geocoding Toolbox";
    };
    passthru.top_level = false;
  };



  "gpsoauth" = python.mkDerivation {
    name = "gpsoauth-0.3.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/1a/e0/2d4eb28074c2168732251b01d833673f5cba379f8bbf12c4e53528946cc3/gpsoauth-0.3.0.tar.gz";
      sha256= "b3963375cd758a3c0ae9ceda044bebe954c25418ed76f977450a6197d38cdb7e";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."pycryptodomex"
      self."requests"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "A python client library for Google Play Services OAuth.";
    };
    passthru.top_level = false;
  };



  "imagesize" = python.mkDerivation {
    name = "imagesize-0.7.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/53/72/6c6f1e787d9cab2cc733cf042f125abec07209a58308831c9f292504e826/imagesize-0.7.1.tar.gz";
      sha256= "0ab2c62b87987e3252f89d30b7cedbec12a01af9274af9ffa48108f2c13c6062";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Getting image size from png/jpeg/jpeg2000/gif file";
    };
    passthru.top_level = false;
  };



  "itsdangerous" = python.mkDerivation {
    name = "itsdangerous-0.24";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/dc/b4/a60bcdba945c00f6d608d8975131ab3f25b22f2bcfe1dab221165194b2d4/itsdangerous-0.24.tar.gz";
      sha256= "cbb3fcf8d3e33df861709ecaf89d9e6629cff0a217bc2848f1b41cd30d360519";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "";
      description = "Various helpers to pass trusted data to untrusted environments and back.";
    };
    passthru.top_level = false;
  };



  "livereload" = python.mkDerivation {
    name = "livereload-2.4.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/d3/fb/fa04cd6a08cc42e1ac089220b6f42d124d01aeb0c70fbe169a73713ca636/livereload-2.4.1.tar.gz";
      sha256= "887cc9976d72d7616fa57c82c4ef5bf5da27e2350dfd6f65d3f44e86efc51b92";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."six"
      self."tornado"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Python LiveReload is an awesome tool for web developers";
    };
    passthru.top_level = false;
  };



  "pathtools" = python.mkDerivation {
    name = "pathtools-0.1.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/e7/7f/470d6fcdf23f9f3518f6b0b76be9df16dcc8630ad409947f8be2eb0ed13a/pathtools-0.1.2.tar.gz";
      sha256= "7c35c5421a39bb82e58018febd90e3b6e5db34c5443aaaf742b3f33d4655f1c0";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "File system general utilities";
    };
    passthru.top_level = false;
  };



  "peewee" = python.mkDerivation {
    name = "peewee-2.8.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/59/4a/a1b78b0e47e880c07da21d633ff2ac8d5edbf969049a414edfbdadaed869/peewee-2.8.1.tar.gz";
      sha256= "9fdb90124d95c02b470a23e06ae40751657d13a425d10ff39ae12943ecd7987d";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "";
      description = "a little orm";
    };
    passthru.top_level = false;
  };



  "pgoapi" = python.mkDerivation {
    name = "pgoapi-1.1.6";
    src = pkgs.fetchurl {
      url = "https://github.com/jb55/pgoapi/archive/master.tar.gz";
      sha256= "50974aee8acd3fb50a76ae80536ca767ab153e77e66519489f288e76b36d24d6";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."geopy"
      self."gpsoauth"
      self."protobuf"
      self."requests"
      self."s2sphere"
      self."six"
      self."xxhash"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "";
      description = "Pokemon Go API lib";
    };
    passthru.top_level = false;
  };



  "port-for" = python.mkDerivation {
    name = "port-for-0.3.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/ec/f1/e7d7a36b5f3e77fba587ae3ea4791512ffff74bc1d065d6185e463279bc4/port-for-0.3.1.tar.gz";
      sha256= "b16a84bb29c2954db44c29be38b17c659c9c27e33918dec16b90d375cc596f1c";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "MIT license";
      description = "Utility that helps with local TCP ports managment. It can find an unused TCP localhost port and remember the association.";
    };
    passthru.top_level = false;
  };



  "protobuf" = python.mkDerivation {
    name = "protobuf-3.0.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/14/3e/56da1ecfa58f6da0053a523444dff9dfb8a18928c186ad529a24b0e82dec/protobuf-3.0.0.tar.gz";
      sha256= "ecc40bc30f1183b418fe0ec0c90bc3b53fa1707c4205ee278c6b90479e5b6ff5";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."six"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "New BSD License";
      description = "Protocol Buffers";
    };
    passthru.top_level = false;
  };



  "pycryptodomex" = python.mkDerivation {
    name = "pycryptodomex-3.4.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/67/9a/a9b49b2225af75bab5328b987f5cf3fd73306188b9272bd69bcf8c57ef04/pycryptodomex-3.4.2.tar.gz";
      sha256= "66489980aa0dd97dce28171c5f42e9862d33cc354a518e52a7bad0699d9b402a";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "";
      description = "Cryptographic library for Python";
    };
    passthru.top_level = false;
  };



  "pyproj" = python.mkDerivation {
    name = "pyproj-1.9.5.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/29/72/5c1888c4948a0c7b736d10e0f0f69966e7c0874a660222ed0a2c2c6daa9f/pyproj-1.9.5.1.tar.gz";
      sha256= "53fa54c8fa8a1dfcd6af4bf09ce1aae5d4d949da63b90570ac5ec849efaf3ea8";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "OSI Approved";
      description = "Python interface to PROJ.4 library";
    };
    passthru.top_level = false;
  };



  "pysqlite" = python.mkDerivation {
    name = "pysqlite-2.8.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/cc/a4/023ee9dba54b3cf0c5a4d0fb2f1ad80332ef23549dd4b551a9f2cbe88786/pysqlite-2.8.2.tar.gz";
      sha256= "613d139e97ce0561dee312e29f3be4751d01fd1a085aa448dd53a003810e0008";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "zlib/libpng license";
      description = "DB-API 2.0 interface for SQLite 3.x";
    };
    passthru.top_level = false;
  };



  "pytz" = python.mkDerivation {
    name = "pytz-2016.6.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/f7/c7/08e54702c74baf9d8f92d0bc331ecabf6d66a56f6d36370f0a672fc6a535/pytz-2016.6.1.tar.bz2";
      sha256= "b5aff44126cf828537581e534cc94299b223b945a2bb3b5434d37bf8c7f3a10c";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "World timezone definitions, modern and historical";
    };
    passthru.top_level = false;
  };



  "recommonmark" = python.mkDerivation {
    name = "recommonmark-0.4.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/3d/95/aa1085573adf3dc7b164ae8569d57b1af5e98922e40345bb7efffed5ad2e/recommonmark-0.4.0.tar.gz";
      sha256= "6e29c723abcf5533842376d87c4589e62923ecb6002a8e059eb608345ddaff9d";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."CommonMark"
      self."docutils"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "";
      description = "UNKNOWN";
    };
    passthru.top_level = false;
  };



  "requests" = python.mkDerivation {
    name = "requests-2.10.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz";
      sha256= "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.asl20;
      description = "Python HTTP for Humans.";
    };
    passthru.top_level = false;
  };



  "s2sphere" = python.mkDerivation {
    name = "s2sphere-0.2.4";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/59/49/c39a5563d6e1f244d72a384da828039d184c1c4d0b2ba3cf0ee3fb41caf1/s2sphere-0.2.4.tar.gz";
      sha256= "6e8b32b5e9c7d0c06bdd31f7c8dac39e23d81c5ff0a3c7bf1e08fed626d9f256";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."Sphinx"
      self."future"
      self."sphinx-rtd-theme"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Python implementation of the S2 Geometry Library";
    };
    passthru.top_level = false;
  };



  "singledispatch" = python.mkDerivation {
    name = "singledispatch-3.4.0.3";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz";
      sha256= "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."six"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "This library brings functools.singledispatch from Python 3.4 to Python 2.6-3.3.";
    };
    passthru.top_level = false;
  };



  "six" = python.mkDerivation {
    name = "six-1.10.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz";
      sha256= "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Python 2 and 3 compatibility utilities";
    };
    passthru.top_level = true;
  };



  "snowballstemmer" = python.mkDerivation {
    name = "snowballstemmer-1.2.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/20/6b/d2a7cb176d4d664d94a6debf52cd8dbae1f7203c8e42426daa077051d59c/snowballstemmer-1.2.1.tar.gz";
      sha256= "919f26a68b2c17a7634da993d91339e288964f93c274f1343e3bbbe2096e1128";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "This package provides 16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms.";
    };
    passthru.top_level = false;
  };



  "sphinx-autobuild" = python.mkDerivation {
    name = "sphinx-autobuild-0.6.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/85/cf/25b65781e6d2a4a89a431260daf1e0d53a81c52d27c98245481d46f3df2a/sphinx-autobuild-0.6.0.tar.gz";
      sha256= "2f9262d7a35f80a18c3bcb03b2bf5a83f0a5e88b75ad922b3b1cee512c7e5cd2";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."PyYAML"
      self."argh"
      self."livereload"
      self."pathtools"
      self."port-for"
      self."tornado"
      self."watchdog"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Watch a Sphinx directory and rebuild the documentation when a change is detected. Also includes a livereload enabled web server.";
    };
    passthru.top_level = false;
  };



  "sphinx-rtd-theme" = python.mkDerivation {
    name = "sphinx-rtd-theme-0.1.9";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/99/b5/249a803a428b4fd438dd4580a37f79c0d552025fb65619d25f960369d76b/sphinx_rtd_theme-0.1.9.tar.gz";
      sha256= "273846f8aacac32bf9542365a593b495b68d8035c2e382c9ccedcac387c9a0a1";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."Sphinx"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "ReadTheDocs.org theme for Sphinx, 2013 version.";
    };
    passthru.top_level = false;
  };



  "tornado" = python.mkDerivation {
    name = "tornado-4.4.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/96/5d/ff472313e8f337d5acda5d56e6ea79a43583cc8771b34c85a1f458e197c3/tornado-4.4.1.tar.gz";
      sha256= "371d0cf3d56c47accc66116a77ad558d76eebaa8458a6b677af71ca606522146";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."backports-abc"
      self."certifi"
      self."singledispatch"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "http://www.apache.org/licenses/LICENSE-2.0";
      description = "Tornado is a Python web framework and asynchronous networking library, originally developed at FriendFeed.";
    };
    passthru.top_level = false;
  };



  "watchdog" = python.mkDerivation {
    name = "watchdog-0.8.3";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/54/7d/c7c0ad1e32b9f132075967fc353a244eb2b375a3d2f5b0ce612fd96e107e/watchdog-0.8.3.tar.gz";
      sha256= "7e65882adb7746039b6f3876ee174952f8eaaa34491ba34333ddf1fe35de4162";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."PyYAML"
      self."argh"
      self."pathtools"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.asl20;
      description = "Filesystem events monitoring";
    };
    passthru.top_level = false;
  };



  "wsgiref" = python.mkDerivation {
    name = "wsgiref-0.1.2";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/41/9e/309259ce8dff8c596e8c26df86dbc4e848b9249fd36797fd60be456f03fc/wsgiref-0.1.2.zip";
      sha256= "c7e610c800957046c04c8014aab8cce8f0b9f0495c8cd349e57c1f7cabf40e79";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "PSF or ZPL";
      description = "WSGI (PEP 333) Reference Library";
    };
    passthru.top_level = false;
  };



  "xxhash" = python.mkDerivation {
    name = "xxhash-0.6.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/08/ac/f5cf4fc624ef5a12a8c6e80143ee43d9ed8d0c8bda96e2af5772798bcfbe/xxhash-0.6.1.tar.bz2";
      sha256= "8048b482bb6aa73016e672d1ef488a89810c2b8e6831366e92c2c67a3b2b151c";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Python binding for xxHash";
    };
    passthru.top_level = false;
  };

}