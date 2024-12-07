# A Minimal Lambda Node.js Runtime Built With Nix!

This repository contains the source code needed to build the Lambda Node.js runtime that I've described 
[on my blog](https://sebastian-staffa.eu/posts/minimal-lambda-containers-with-nix). 

To build the smallest image possible, that is described and tested at the end of the article, you can use the default 
flake output:

```shell
nix build 
```

To load the image into docker, use the following command:
```shell    
docker load -i $(nix build --print-out-paths)
```

You can also build any other intermediate step that is described in the blog post. Use `nix flake show` to see all
available outputs. The naming uses the following schema:
```
[node]-[intl]-[locales]-[rie]
```
- `node` is either `slim` or `full` and controls whether the full or slim nixpkgs node.js package is used.
- `intl` is either `intl` or `no-intl` and controls whether node is compiled with `Intl` support.
- `locales` is either `locales` or `no-locales` and controls whether the locales are stripped from the glibc
- `rie` is either `rie` or `no-rie` and controls whether the Lambda Runtime Interface Emulator is included to allow for local execution of the image.

```
$ nix flake show

├───formatter
│   ├───[omitted]
│   └───x86_64-linux: package 'alejandra-3.0.0'
└───packages
    ├───[omitted]
    └───x86_64-linux
        ├───default: package 'docker-image-node_slim_no-intl_no-locales_no-rie.tar.gz'
        ├───full_intl_locales_no-rie: package 'docker-image-node_full_intl_locales_no-rie.tar.gz'
        ├───full_intl_locales_rie: package 'docker-image-node_full_intl_locales_rie.tar.gz'
        ├───full_intl_no-locales_no-rie: package 'docker-image-node_full_intl_no-locales_no-rie.tar.gz'
        ├───full_intl_no-locales_rie: package 'docker-image-node_full_intl_no-locales_rie.tar.gz'
        ├───full_no-intl_locales_no-rie: package 'docker-image-node_full_no-intl_locales_no-rie.tar.gz'
        ├───full_no-intl_locales_rie: package 'docker-image-node_full_no-intl_locales_rie.tar.gz'
        ├───full_no-intl_no-locales_no-rie: package 'docker-image-node_full_no-intl_no-locales_no-rie.tar.gz'
        ├───full_no-intl_no-locales_rie: package 'docker-image-node_full_no-intl_no-locales_rie.tar.gz'
        ├───minimal: package 'docker-image-node_slim_no-intl_no-locales_no-rie.tar.gz'
        ├───slim_intl_locales_no-rie: package 'docker-image-node_slim_intl_locales_no-rie.tar.gz'
        ├───slim_intl_locales_rie: package 'docker-image-node_slim_intl_locales_rie.tar.gz'
        ├───slim_intl_no-locales_no-rie: package 'docker-image-node_slim_intl_no-locales_no-rie.tar.gz'
        ├───slim_intl_no-locales_rie: package 'docker-image-node_slim_intl_no-locales_rie.tar.gz'
        ├───slim_no-intl_locales_no-rie: package 'docker-image-node_slim_no-intl_locales_no-rie.tar.gz'
        ├───slim_no-intl_locales_rie: package 'docker-image-node_slim_no-intl_locales_rie.tar.gz'
        ├───slim_no-intl_no-locales_no-rie: package 'docker-image-node_slim_no-intl_no-locales_no-rie.tar.gz'
        └───slim_no-intl_no-locales_rie: package 'docker-image-node_slim_no-intl_no-locales_rie.tar.gz'
```

For example, use `nix build .#slim_intl_locales_rie` to build the container using the `slim` Node.js package, 
with `Intl` support, locales and local execution support.