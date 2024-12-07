{
  pkgs,
  minifiedNode,
  buildNode,
}:
with pkgs; let
  lambdaRic =
    (import ./aws-lambda-ric.nix {
      nodejs = buildNode;
      inherit buildNpmPackage fetchFromGitHub gcc libgnurl autoconf271 automake cmake libtool perl lib;
    })
    .overrideAttrs (oldAttrs: {
      # real problem lies here https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/node/build-npm-package/hooks/npm-config-hook.sh#L103
      # patchShebang should run with host deps?
      postFixup = ''
        escapedNewInterpeter=$(printf '%s\n' "${minifiedNode}" | sed -e 's/[\/&]/\\&/g')
        escapedOldInterpeter=$(printf '%s\n' "${buildNode}" | sed -e 's/[]\/$*.^[]/\\&/g')
        find $out -type f -print0 | xargs -0 sed -i "s/$escapedOldInterpeter/$escapedNewInterpeter/g"
      '';
    });
in
  lambdaRic
