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
    binName = super.lib.toLower pname;
    version = "85.0";
    description = "The Firefox web browser";
    homepage = "https://www.mozilla.org/en-GB/firefox";
    extraBuildInputs = [ super.makeWrapper ];
    postInstall = ''
      makeWrapper $out/Applications/${pname}.app/Contents/MacOS/${binName} $out/bin/${binName}
    '';
    src = {
      name = "Firefox-${version}.dmg";
      url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
      sha256 = "0ixdxdpfnp34yxxp3smm17j6hf6bppipc5bsd1qdq18745fgj0pa";
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

  telegram = installApp rec {
    pname = "Telegram";
    version = "2.5";
    description = "A new era of messaging";
    homepage = "https://macos.telegram.org";
    src = {
      url = "https://osx.telegram.org/updates/Telegram.dmg";
      sha256 = "1hgv9yclf9rfai55xhxcq46ab86qpcxj2ayggjr53dp41pazimka";
    };
  };

  iterm2 = installApp rec {
    pname = "iTerm2";
    appname = "iTerm";
    version = "3.4.3";
    downloadVersion = super.lib.replaceStrings [ "." ] [ "_" ] version;
    description = "iTerm2 is a replacement for Terminal and the successor to iTerm.";
    homepage = "https://iterm2.com";
    extraBuildInputs = [ super.unzip ];
    src = {
      url = "https://iterm2.com/downloads/stable/${pname}-${downloadVersion}.zip";
      sha256 = "1fgnm2mfp3n14ba8rlvl7y630w9pvbvyadyzxabzgpcbhd23imwy";
    };
  };

  chrome-canary = installApp rec {
    pname = "GoogleChromeCanary";
    appname = "Google Chrome Canary";
    version = "1.0.0";
    description = "Nightly build for developers";
    homepage = "https://www.google.com/intl/en/chrome/canary/";
    src = {
      url = "https://dl.google.com/chrome/mac/canary/googlechromecanary.dmg";
      sha256 = "01j9p9vvqrwsp6h70mb03jx0wql705y24x0vs5hzapzv4zy847xf";
    };
  };
}
