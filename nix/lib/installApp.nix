{ stdenv, fetchurl, undmg, ... }:

{
  pname,
  appname ? pname,
  version,
  src,
  description,
  homepage,
  postInstall ? "",
  sourceRoot ? ".",
  ...
}:

stdenv.mkDerivation {
  pname = pname;
  version = version;
  src = fetchurl src;

  buildInputs = [ undmg ];
  sourceRoot = sourceRoot;
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r "${appname}.app" "$out/Applications/${appname}.app"
  '' + postInstall;

  meta = with stdenv.lib; {
    description = description;
    homepage = homepage;
    maintainers = with maintainers; [ akoppela ];
    platforms = platforms.darwin;
  };
}