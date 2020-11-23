self: super:
let
  installApp = import ../lib/installApp.nix super;
in
{
  alfred = installApp rec {
    pname = "Alfred";
    appname = "Alfred 4";
    version = "4.1.1";
    build = "1172";
    description = "Alfred for Mac";
    homepage = "https://www.alfredapp.com";
    src = {
      url = "https://cachefly.alfredapp.com/Alfred_${version}_${build}.dmg";
      sha256 = "0m31xxkqv0j57kmhwxwhq5ml2dg635sv7bg5mcjj4d2s9p77g3bs";
    };
  };

  firefox = installApp rec {
    pname = "Firefox";
    version = "82.0";
    description = "The Firefox web browser";
    homepage = "https://www.mozilla.org/en-GB/firefox";
    src = {
      name = "Firefox-${version}.dmg";
      url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
      sha256 = "0hrhwzj2fhashariy7c8xyq4fz08zpxmmi8lk74zxkj7qhlba5mr";
    };
  };

  chrysalis  = installApp rec {
    pname = "Chrysalis";
    version = "0.7.9";
    description = "Chrysalis is a graphical configurator for Kaleidoscope-powered keyboards.";
    homepage = "https://github.com/keyboardio/Chrysalis";
    src = {
      url = "https://github.com/keyboardio/Chrysalis/releases/download/chrysalis-${version}/Chrysalis-${version}.dmg";
      sha256 = "1iznbgh04q7gfh7ndf94yh7z6xnw8jixkncnk594akvbkmpyvwq0";
    };
  };
}