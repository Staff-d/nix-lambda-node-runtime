{pkgs ? import <nixpkgs> {}}:
with pkgs; let
  ric = import ./aws-lambda-ric.nix {
    nodejs = nodejs_20;
    inherit buildNpmPackage fetchFromGitHub gcc libgnurl autoconf271 automake cmake libtool perl lib;
  };
in
  ric
