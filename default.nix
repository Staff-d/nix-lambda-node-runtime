{
  pkgs ? import (import ./pinned-nixpkgs.nix) {},
  stripGlibcLocales ? true,
  stripNodeIntl ? true,
  useSlimInterpreter ? true,
  addLambdaRie ? false,
}: let
  glibcNoLocales = import ./glibc/glibc-no-locales.nix {
    glibc = pkgs.glibc;
    lib = pkgs.lib;
  };

  moddedPkgs =
    if stripGlibcLocales
    then pkgs.extend (self: super: {glibc = glibcNoLocales;})
    else pkgs;

  buildNode = moddedPkgs.nodejs_20;
  minifiedNode =
    if stripNodeIntl
    then
      import ./node/minified-node.nix {
        lib = pkgs.lib;
        nodeToMinify = moddedPkgs.nodejs-slim_20;
      }
    else moddedPkgs.nodejs-slim_20;

  lambdaRic = import ./aws-lambda-ric/lambda-ric-with-interpreter.nix {
    buildNode = moddedPkgs.nodejs_20;
    pkgs = moddedPkgs;
    minifiedNode =
      if useSlimInterpreter
      then minifiedNode
      else buildNode;
  };

  handler = import ./handler/handler.nix {pkgs = moddedPkgs;};
in
  pkgs.dockerTools.buildImage {
    name = pkgs.lib.strings.concatStringsSep "_" [
      "node"
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
    ];
    tag = "latest";

    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      paths =
        [
          lambdaRic
          handler
        ]
        ++ (
          if addLambdaRie
          then [pkgs.aws-lambda-rie]
          else []
        );
      pathsToLink = ["/bin"];
    };

    config = {
      Cmd =
        (
          if addLambdaRie
          then ["/bin/aws-lambda-rie"]
          else []
        )
        ++ [
          "/bin/aws-lambda-ric"
          "${handler}/lib/handler.handler"
        ];
    };
  }
