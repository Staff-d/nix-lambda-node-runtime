{pkgs ? import <nixpkgs> {}}: let
  handler = import ../handler/handler.nix {inherit pkgs;};
in
  pkgs.dockerTools.buildImage {
    name = "node-plus-handler-test";
    tag = "latest";

    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      paths = [pkgs.nodejs_20 handler];
      pathsToLink = ["/bin"];
    };
    config = {
      Cmd = ["/bin/node" "${handler}/lib/handler.js"];
    };
  }
