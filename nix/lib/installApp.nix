{ stdenv, fetchurl, undmg, ... }:

{ pname
, appname ? pname
, version
, src
, description
, homepage
, postInstall ? ""
, sourceRoot ? "."
, ...
}:

stdenv.mkDerivation {
  pname = pname;
  version = version;
  src = fetchurl src;

  buildInputs = [
    undmg
  ];
  sourceRoot = sourceRoot;
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r "${appname}.app" "$out/Applications/${appname}.app"
  '' + postInstall;

  meta = {
    description = stdenv.lib.description;
    homepage = stdenv.lib.homepage;
    maintainers = [
      stdenv.lib.maintainers.akoppela
    ];
    platforms = stdenv.lib.platforms.darwin;
  };
}
