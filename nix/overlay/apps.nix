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

  jetbrains = super.jetbrains // {
    jdk = super.stdenv.mkDerivation rec {
      pname = "jetbrainsjdk";
      version = "702.1";
      darwinVersion = "11_0_6-osx-x64-b${version}";

      src = super.fetchurl {
	      url = "https://bintray.com/jetbrains/intellij-jbr/download_file?file_path=jbrsdk-${darwinVersion}.tar.gz";
	      sha256 = "1ra33mp71awhmzf735dq7hxmx9gffsqj9cdp51k5xdmnmb66g12s";
      };

      nativeBuildInputs = [ super.file ];
      unpackCmd = "mkdir jdk; pushd jdk; tar -xzf $src; popd";
      installPhase = ''
	      cd ..;
	      mv $sourceRoot/jbrsdk $out;
      '';

      passthru.home = "${self.jetbrains.jdk}/Contents/Home";

      meta = with super.stdenv.lib; {
	      description = "An OpenJDK fork to better support Jetbrains's products.";
	      longDescription = ''
	        JetBrains Runtime is a runtime environment for running IntelliJ Platform
	        based products on Windows, Mac OS X, and Linux. JetBrains Runtime is
	        based on OpenJDK project with some modifications. These modifications
	        include: Subpixel Anti-Aliasing, enhanced font rendering on Linux, HiDPI
	        support, ligatures, some fixes for native crashes not presented in
	        official build, and other small enhancements.

	        JetBrains Runtime is not a certified build of OpenJDK. Please, use at
	        your own risk.
	      '';
	      homepage = "https://bintray.com/jetbrains/intellij-jdk/";
	      documentation = "https://confluence.jetbrains.com/display/JBR/JetBrains+Runtime";
	      license = licenses.gpl2;
	      maintainers = with maintainers; [ edwtjo ];
	      platforms = with platforms; [ "x86_64-linux" "x86_64-darwin" ];
      };
    };
  };
}