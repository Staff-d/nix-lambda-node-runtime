{pkgs ? import <nixpkgs> {}}: let
  fs = pkgs.lib.fileset;
in
  pkgs.stdenv.mkDerivation {
    name = "example-aws-lambda-handler";
    src = fs.toSource {
      root = ./.;
      fileset = ./handler.js;
    };
    postInstall = ''
      mkdir -p $out/lib
      cp -v handler.js $out/lib
    '';
  }
