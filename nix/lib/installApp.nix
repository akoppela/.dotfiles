{ stdenv, lib, fetchurl, undmg, ... }:

{ pname
, appname ? pname
, version
, src
, description
, homepage
, postInstall ? ""
, sourceRoot ? "."
, extraBuildInputs ? [ ]
, ...
}:

stdenv.mkDerivation {
  pname = pname;
  version = version;
  src = fetchurl src;

  buildInputs = [ undmg ] ++ extraBuildInputs;
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
    description = description;
    homepage = homepage;
    maintainers = [ lib.maintainers.akoppela ];
    platforms = lib.platforms.darwin;
  };
}
