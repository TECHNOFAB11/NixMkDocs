{inputs, ...}: let
  inherit (inputs) pkgs doclib;

  optionsDoc = doclib.mkOptionDocs {
    module = doclib.modules.nixMkDocsSubmodule;
    roots = [
      {
        url = "https://gitlab.com/TECHNOFAB/nix-mkdocs/-/blob/main/lib";
        path = "${inputs.self}/lib";
      }
    ];
  };
  optionsDocs = pkgs.runCommand "options-docs" {} ''
    mkdir -p $out
    ln -s ${optionsDoc} $out/options.md
  '';
in
  (doclib.mkDocs {
    docs."default" = {
      base = "${inputs.self}";
      path = "${inputs.self}/docs";
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
        includeDir = toString optionsDocs;
      };
      dynamic-nav = {
        enable = true;
        files."Dynamic Nav Plugin" = [
          {"Look im below E!" = builtins.toFile "test.md" "This is generated from Nix and the order works!";}
          {"Example Entry" = builtins.toFile "test.md" "Hello from Nix!";}
        ];
      };

      config = {
        site_name = "NixMkDocs";
        site_url = "https://nix-mkdocs.projects.tf";
        repo_name = "TECHNOFAB/nix-mkdocs";
        repo_url = "https://gitlab.com/TECHNOFAB/nix-mkdocs";
        extra_css = ["style.css"];
        theme = {
          logo = "images/logo.svg";
          icon.repo = "simple/gitlab";
          favicon = "images/logo.svg";
        };
        nav = [
          {"Introduction" = "index.md";}
          {"Getting Started" = "getting-started.md";}
          {"Packages" = "packages.md";}
          {"Examples" = "examples.md";}
          {"Plugins" = "plugins.md";}
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
          "admonition"
        ];
      };
    };
  }).packages
  // {
    inherit optionsDocs;
  }
