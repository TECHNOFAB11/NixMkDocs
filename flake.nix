{
  outputs = {
    flake-parts,
    systems,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.nix-gitlab-ci.flakeModule
        ./lib/flakeModule.nix
      ];
      systems = import systems;
      flake = {};
      perSystem = {
        pkgs,
        config,
        ...
      }: {
        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            mdformat.enable = true;
          };
        };
        devenv.shells.default = {
          containers = pkgs.lib.mkForce {};
          packages = [];

          pre-commit.hooks.treefmt = {
            enable = true;
            packageOverrides.treefmt = config.treefmt.build.wrapper;
          };
        };
        doc = {
          path = ./docs;
          deps = pp: [pp.mkdocs-material];
          config = {
            site_name = "Site Name";
            theme.name = "material";
          };
        };
        docs."test" = {
          path = ./docs;
        };
        ci = {
          stages = ["build" "deploy"];
          jobs = {
            "docs" = {
              stage = "build";
              script = [
                # sh
                ''
                  nix build .#docs:default
                  mkdir -p public
                  cp -r result/ public/
                ''
              ];
              artifacts.paths = ["public"];
            };
            "pages" = {
              image = "alpine:latest";
              stage = "deploy";
              script = ["true"];
              artifacts.paths = ["public"];
              rules = [
                {
                  "if" = "$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH";
                }
              ];
            };
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # flake & devenv related
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default-linux";
    devenv.url = "github:cachix/devenv";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nix-gitlab-ci.url = "gitlab:technofab/nix-gitlab-ci/feat/v2?dir=lib";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };
}
