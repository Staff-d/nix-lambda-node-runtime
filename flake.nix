{
  description = "A flake to built all permutations of the minimal Lambda Docker runtime, as described in http://sebastian-staffa.eu/posts/minimal-lambda-containers-with-nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=d51c28603def282a24fa034bcb007e2bcb5b5dd0";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        formatter = pkgs.alejandra;
        packages =
          rec {
            default = minimal;
            minimal = import ./default.nix {inherit pkgs;};
          }
          // builtins.listToAttrs (
            pkgs.lib.mapCartesianProduct ({
              stripGlibcLocales,
              stripNodeIntl,
              useSlimInterpreter,
              addLambdaRie,
            }:
              pkgs.lib.attrsets.nameValuePair
              (pkgs.lib.strings.concatStringsSep "_" [
                (
                  if useSlimInterpreter
                  then "slim"
                  else "full"
                )
                (
                  if stripNodeIntl
                  then "no-intl"
                  else "intl"
                )
                (
                  if stripGlibcLocales
                  then "no-locales"
                  else "locales"
                )
                (
                  if addLambdaRie
                  then "rie"
                  else "no-rie"
                )
              ])
              (import ./default.nix {inherit stripGlibcLocales stripNodeIntl useSlimInterpreter addLambdaRie pkgs;})) {
              stripGlibcLocales = [true false];
              stripNodeIntl = [true false];
              useSlimInterpreter = [true false];
              addLambdaRie = [true false];
            }
          );
      }
    );
}
