{
  glibc,
  lib,
  localesToKeep ? [],
  charmapsToKeep ? [],
}: let
  glibCLocales = localesToKeep ++ ["C"];
  glibCCharmaps = charmapsToKeep ++ ["UTF-8"];

  minGlibC = glibc.overrideAttrs (oldAttrs: {
    postInstall =
      oldAttrs.postInstall
      + ''
        find $out/share/i18n/locales -type f ${lib.concatMapStringsSep " " (l: "-not -name '${l}'") glibCLocales} -exec rm {} \;
        find $out/share/i18n/charmaps -type f ${lib.concatMapStringsSep " " (l: "-not -name '${l}.gz'") glibCCharmaps} -exec rm {} \;
      '';
  });
in
  minGlibC
