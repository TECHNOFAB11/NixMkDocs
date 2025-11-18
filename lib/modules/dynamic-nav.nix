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
      version = "0.1.0";
      pyproject = true;

      src = fetchFromGitLab {
        owner = "TECHNOFAB";
        repo = "mkdocs-dynamic-nav";
        rev = "1907f85b90d8cf379f6b2990966cb42201a8bd90";
        hash = "sha256-iEf5qwe8Qu2zW9nvQaHfYw+pWlwDMLOTfKhNGgm7tSU=";
      };
      nativeBuildInputs = [setuptools];

      propagatedBuildInputs = [
        mkdocs
        mkdocs-material
      ];
    };
in {
  options.dynamic-nav = {
    enable = mkEnableOption "mkdocs-dynamic-nav";
    files = mkOption {
      type = types.either (types.attrsOf types.anything) (types.listOf types.anything);
      default = {};
      example = {
        "TopLevel"."SubLevel" = "/nix/store/...";
      };
      description = ''
        Mapping of nav-titles to files or nested mappings.
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
