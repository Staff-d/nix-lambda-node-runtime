{pkgs ? import <nixpkgs> {}}:
pkgs.dockerTools.buildImage {
  name = "node-only-test";
  tag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [pkgs.nodejs_20];
    pathsToLink = ["/bin"];
  };
  config = {
    Cmd = ["/bin/node"];
  };
}
