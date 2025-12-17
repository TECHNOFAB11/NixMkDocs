{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types optional;
  cfg = config.material.umami;

  package = {
    fetchFromGitLab,
    buildPythonPackage,
    setuptools,
    mkdocs,
    mkdocs-material,
  }:
    buildPythonPackage {
      pname = "[mkdocs-material-umami](https://gitlab.com/TECHNOFAB/mkdocs-material-umami)";
      version = "0.1.0";
      pyproject = true;

      src = fetchFromGitLab {
        owner = "TECHNOFAB";
        repo = "mkdocs-material-umami";
        rev = "3ac9b194450f6b779c37b8d16fec640198e5cd0a";
        hash = "sha256-1Ad1JTMQMP6YsoIKAA+SBCE15qWrYkGue9/lXOLnu9I=";
      };
      nativeBuildInputs = [setuptools];

      propagatedBuildInputs = [
        mkdocs
        mkdocs-material
      ];
    };
in {
  options.material.umami = {
    enable = mkEnableOption "material-umami";
    siteId = mkOption {
      type = types.str;
      description = ''
        The site ID from Umami, can be found in the dashboard's URL for example.
      '';
      example = "6f7d66a1-392f-49db-b0d5-fca931724f2d";
    };
    src = mkOption {
      type = types.str;
      description = ''
        The URL where the tracking script is loaded from.
      '';
      example = "https://analytics.example.com/umami";
    };
    domains = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        List of domains where the tracking should activate.
        This makes it possible to have staging envs or whatever, without
        Umami tracking stuff.
      '';
    };
    enableFeedback = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable the "Feedback" widget at the bottom of a page.
      '';
    };
  };

  config.deps = p: optional cfg.enable (p.callPackage package {});
  config.config =
    if cfg.enable
    then {
      plugins = ["material-umami"];
      extra.analytics = {
        provider = "umami";
        site_id = cfg.siteId;
        inherit (cfg) src;
        domains = builtins.concatStringsSep "," cfg.domains;
        feedback =
          if cfg.enableFeedback
          then {
            title = "Was this page helpful?";
            ratings = [
              {
                icon = "material/thumb-up-outline";
                name = "This page is helpful";
                data = "good";
                note = "Thanks for your feedback!";
              }
              {
                icon = "material/thumb-down-outline";
                name = "This page could be improved";
                data = "bad";
                note = "Thanks for your feedback!";
              }
            ];
          }
          else null;
      };
    }
    else {};
}
