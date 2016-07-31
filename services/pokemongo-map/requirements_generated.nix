# generated using pypi2nix tool (version: 1.3.0dev)
#
# COMMAND:
#   pypi2nix -V 2.7 -r requirements.txt -E stdenv -E sqlite
#

{ pkgs, python, commonBuildInputs ? [], commonDoCheck ? false }:

self: {

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
    passthru.top_level = true;
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
      self."MarkupSafe"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "A small but fast and easy to use stand-alone template engine written in pure python.";
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
    propagatedBuildInputs = [ ];
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



  "protobuf" = python.mkDerivation {
    name = "protobuf-2.6.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/2c/05/10c2611da9149677abfae24e208761794561e406c37d78c36bd8dda8ea80/protobuf-2.6.1.tar.gz";
      sha256= "8faca1fb462ee1be58d00f5efb4ca4f64bde92187fe61fde32615bbee7b3e745";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "New BSD License";
      description = "Protocol Buffers";
    };
    passthru.top_level = false;
  };



  "protobuf-to-dict" = python.mkDerivation {
    name = "protobuf-to-dict-0.1.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/58/67/5f5702d8f593ec0697a1ae53d18be71f7727155f5b221c94fcecf2bf3e6d/protobuf-to-dict-0.1.0.tar.gz";
      sha256= "dd152977f4c39942d3e1a233f6b3df35c548fffddfeda1fb88cb3b52a3b366e7";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."protobuf"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "Public Domain";
      description = "A teeny Python library for creating Python dicts from protocol buffers and the reverse. Useful as an intermediate step before serialisation (e.g. to JSON).";
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
      self."future"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Python implementation of the S2 Geometry Library";
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

}
