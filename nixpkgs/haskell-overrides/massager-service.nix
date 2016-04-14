{ mkDerivation, base, bytestring, cassava, flexible-instances
, http-types, payment, data-default, pipes, pipes-csv, stdenv, streaming
, streaming-wai, text, unordered-containers, vector, wai, warp
, word8
}:
with stdenv.lib;
mkDerivation {
  pname = "massager-service";
  version = "0.1.0";
  src = /dropbox/projects/monstercat/haskell/massager-service;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring data-default cassava flexible-instances http-types payment
    pipes pipes-csv streaming streaming-wai text unordered-containers
    vector wai warp word8
  ];
  postInstall = ''
    cp -r parsers $out/bin
  '';
  homepage = "https://phabricator.monstercat.com/diffusion/MASRV";
  description = "Match csvs with Connect users and tracks";
  license = stdenv.lib.licenses.mit;
}
