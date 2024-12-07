{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  gcc,
  libgnurl,
  autoconf271,
  automake,
  cmake,
  libtool,
  perl,
  lib,
  prunePython ? true,
}:
buildNpmPackage rec {
  pname = "aws-lambda-nodejs-runtime-interface-client";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5NfhSavcrBlGZ4UYXRqPTXhB3FO0DhRq/2dg15D6tFc=";
  };

  inherit nodejs;
  npmDepsHash = "sha256-XyHystDd+oxwhuNr5jpcqeVdMoEMUiSkvNF9P0M29Hs=";
  nativeBuildInputs = [autoconf271 automake cmake libtool perl];
  buildInputs = [gcc libgnurl];

  dontUseCmakeConfigure = true;

  postInstall = lib.optionalString prunePython ''
    # All dependencies of the ric are not actual
    # runtime deps, but are build deps. We can remove
    # them to reduce the size of the final image.
    rm -rf $nodeModulesPath

    # remove build leftovers
    find $out/lib/node_modules/aws-lambda-ric/deps -maxdepth 1 \
        -not \( -path $out/lib/node_modules/aws-lambda-ric/deps/artifacts -prune \) \
        -not \( -name deps \) \
        -exec rm -rf {} \;
  '';
}
