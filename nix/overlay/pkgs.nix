self: super:

{
  extempore = super.stdenv.mkDerivation rec {
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
        ref = "refs/tags/0.829.5";
      })
      {
        pkgs = super;
      };

  emacs =
    let
      # Disble Cairo as it does not work well with PragmataPro ligatures
      emacsNoCairo =
        super.emacs.overrideAttrs (old: {
          configureFlags = builtins.filter
            (flag: flag != "--with-cairo")
            (old.configureFlags or [ ]);
        });
    in
    (super.emacsPackagesNgGen emacsNoCairo).emacsWithPackages (epkgs: [
      epkgs.vterm
    ]);
}
