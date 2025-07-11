self: super:

{
  extempore =
    super.stdenv.mkDerivation rec {
      pname = "extempore";
      version = "0.8.7";
      src = super.fetchurl {
        url = "https://github.com/digego/${pname}/releases/download/v${version}/${pname}-v${version}-macos-latest.zip";
        sha256 = "01f969iy64z3ns9cy7y8j585hzsayy0kcvcfdhrr1q94ydfsnsvz";
      };

      buildInputs = [
        super.unzip
        super.makeWrapper
      ];
      installPhase = ''
        mkdir -p $out
        cp -R * $out/
        makeWrapper $out/${pname} $out/bin/${pname} --add-flags "--sharedir $out"
      '';

      meta = {
        description = "A programming environment for cyberphysical programming";
        homepage = "https://extemporelang.github.io";
        maintainers = [ super.lib.maintainers.akoppela ];
        platforms = super.lib.platforms.darwin;
      };
    };

  pragmatapro =
    import
      (builtins.fetchGit {
        url = "git@github.com:akoppela/pragmata-pro.git";
        ref = "releases/tag/0.829.6";
        rev = "8a87317558114a5bb83c7a9ca479d4a77584dfea";
      })
      {
        pkgs = super;
      };

  emacs =
    (super.emacsPackagesFor (super.emacs.override { withImageMagick = true; })).emacsWithPackages (epkgs: [
      epkgs.vterm
    ]);

  ledger = (super.ledger.override { gpgmeSupport = true; });
}
