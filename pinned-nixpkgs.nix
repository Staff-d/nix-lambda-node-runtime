let
  spec = {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "d51c28603def282a24fa034bcb007e2bcb5b5dd0";
    sha256 = "sha256-dOymOQ3AfNI4Z337yEwHGohrVQb4yPODCW9MDUyAc4w=";
  };
  url = "https://github.com/${spec.owner}/${spec.repo}/archive/${spec.rev}.tar.gz";
in
  builtins.fetchTarball {
    url = url;
    sha256 = spec.sha256;
  }
