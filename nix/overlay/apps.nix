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

  chrysalis = installApp rec {
    pname = "Chrysalis";
    version = "0.7.9";
    description = "Chrysalis is a graphical configurator for Kaleidoscope-powered keyboards.";
    homepage = "https://github.com/keyboardio/Chrysalis";
    src = {
      url = "https://github.com/keyboardio/Chrysalis/releases/download/chrysalis-${version}/Chrysalis-${version}.dmg";
      sha256 = "1iznbgh04q7gfh7ndf94yh7z6xnw8jixkncnk594akvbkmpyvwq0";
    };
  };

  steam = installApp rec {
    pname = "Steam";
    version = "1.0.0";
    description = "Steam is the ultimate destination for playing, discussing, and creating games.";
    homepage = "https://store.steampowered.com";
    src = {
      url = "https://cdn.cloudflare.steamstatic.com/client/installer/steam.dmg";
      sha256 = "1sd0fr9s75zkbl7wfl3w8rsys5k2dfgfx6ib26ca7pgmm4sp2y6s";
    };
  };

  xld = installApp rec {
    pname = "XLD";
    version = "20201123";
    description = "X Lossless Decoder: Lossless audio decoder for Mac OS X";
    homepage = "https://tmkk.undo.jp/xld";
    src = {
      url = "https://udomain.dl.sourceforge.net/project/xld/xld-20201123.dmg";
      sha256 = "0w1blx8l77aa3inrp6kikq0xkwqd3c1ysm5i0nl4ssc0mj6v7l8s";
    };
  };
}
