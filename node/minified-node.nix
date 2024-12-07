{
  lib,
  nodeToMinify,
}: let
  minifiedNode = nodeToMinify.overrideAttrs (oldAttrs: {
    postInstall =
      oldAttrs.postInstall
      + ''
                rm -rf $out/share
                rm -rf $out/lib
        #        rm -rf $out/include
      '';

    configureFlags =
      (lib.remove "--with-intl=system-icu" (lib.flatten oldAttrs.configureFlags))
      ++ ["--without-intl"];
  });
in
  minifiedNode
