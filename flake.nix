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
        lib,
        pkgs,
        config,
        self',
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
        docs."default".config = {
          path = ./docs;
          material = {
            enable = true;
            colors = {
              primary = "indigo";
              accent = "blue";
            };
            umami = {
              enable = true;
              src = "https://analytics.tf/umami";
              siteId = "57d2c8d2-45c7-4a84-9e72-313f2819e34c";
              domains = ["nix-mkdocs.projects.tf"];
            };
          };
          macros = {
            enable = true;
            includeDir = toString self'.packages.optionsDocs;
          };
          config = {
            site_name = "NixMkDocs";
            repo_name = "TECHNOFAB/nixmkdocs";
            repo_url = "https://gitlab.com/TECHNOFAB/nixmkdocs";
            theme = {
              logo = "images/logo.png";
              icon.repo = "simple/gitlab";
              favicon = "images/favicon.png";
            };
            nav = [
              {"Introduction" = "index.md";}
              {"Getting Started" = "getting-started.md";}
              {"Packages" = "packages.md";}
              {"Examples" = "examples.md";}
              {"Options" = "options.md";}
            ];
            markdown_extensions = [
              {
                "pymdownx.highlight".pygments_lang_class = true;
              }
              "pymdownx.inlinehilite"
              "pymdownx.snippets"
              "pymdownx.superfences"
              "pymdownx.escapeall"
              "fenced_code"
            ];
          };
        };
        docs."test" = {
          path = ./docs;
        };
        ci = {
          stages = ["test" "build" "deploy"];
          jobs = {
            "test" = {
              stage = "test";
              script = [
                "nix run .#tests -- --junit=junit.xml"
              ];
              allow_failure = true;
              artifacts = {
                when = "always";
                reports.junit = "junit.xml";
              };
            };
            "docs" = {
              stage = "build";
              script = [
                # sh
                ''
                  nix build .#docs:default
                  mkdir -p public
                  cp -r result/. public/
                ''
              ];
              artifacts.paths = ["public"];
            };
            "pages" = {
              nix.enable = false;
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

        packages = let
          doclib = import ./lib {inherit lib pkgs;};
          ntlib = inputs.nixtest.lib {inherit lib pkgs;};
          roots = [
            {
              url = "https://gitlab.com/TECHNOFAB/nixmkdocs/-/blob/main/lib";
              path = toString ./lib;
            }
          ];
        in
          rec {
            optionsDoc = doclib.mkOptionDocs {
              module = doclib.modules.nixMkDocsSubmodule;
              inherit roots;
            };
            optionsDocs = pkgs.runCommand "options-docs" {} ''
              mkdir -p $out
              ln -s ${optionsDoc} $out/options.md
            '';
            tests = ntlib.mkNixtest {
              modules = ntlib.autodiscover {dir = ./tests;};
              args = {
                inherit pkgs doclib ntlib self';
              };
            };
          }
          // (doclib.mkDocs {
            docs."example" = {
              path = ./docs;
              config = {};
            };
          })
          .packages;
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # flake & devenv related
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default-linux";
    devenv.url = "github:cachix/devenv";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nix-gitlab-ci.url = "gitlab:technofab/nix-gitlab-ci/2.1.0?dir=lib";
    mkdocs-material-umami.url = "gitlab:technofab/mkdocs-material-umami";
    nixtest.url = "gitlab:technofab/nixtest?dir=lib";
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
