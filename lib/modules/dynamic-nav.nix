{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types optional;
  cfg = config.dynamic-nav;

  package = {
    fetchFromGitLab,
    buildPythonPackage,
    setuptools,
    mkdocs,
    mkdocs-material,
  }:
    buildPythonPackage {
      pname = "mkdocs-dynamic-nav";
      version = "unstablee";
      pyproject = true;

      src = fetchFromGitLab {
        owner = "TECHNOFAB";
        repo = "mkdocs-dynamic-nav";
        rev = "b52fc5dffeb360b509eaec2b822f406fcdf7fd8f";
        hash = "sha256-6WE+qKQxDA2DeGUstPtQ5mOFURUHxU3YWlsd2YAv8mA=";
      };
      nativeBuildInputs = [setuptools];

      propagatedBuildInputs = [
        mkdocs
        mkdocs-material
      ];
    };
in {
  options.dynamic-nav = {
    enable = mkEnableOption "[mkdocs-dynamic-nav](https://gitlab.com/TECHNOFAB/mkdocs-dynamic-nav)";
    files = mkOption {
      type = types.either (types.attrsOf types.anything) (types.listOf types.anything);
      default = {};
      example = {
        "TopLevel"."SubLevel" = "/nix/store/...";
      };
      description = ''
        Mapping of nav-titles to files or nested mappings.
        Use a list to preserve ordering, when using a dict/attrset it will be sorted alphabetically.
      '';
    };
  };
  config.deps = p: optional (cfg.enable) (p.callPackage package {});
  config.config =
    if (cfg.enable)
    then {
      plugins = [
        {
          "dynamic-nav".paths = cfg.files;
        }
      ];
    }
    else {};
}
