{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types optional optionals;
  cfg = config.macros;
in {
  options.macros = {
    enable = mkEnableOption "[mkdocs-macros](https://github.com/fralau/mkdocs-macros-plugin)";
    includeDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Which directory to load includes from. Can be a store path aswell,
        this allows you to generate stuff with Nix and include it, even when
        using the watch mode (but it won't update if it's a store path, so it's
        only generated once when running the watcher).
      '';
    };
    renderByDefault = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to render macros by default (opt-out per page) or not (opt-in per page).
      '';
    };
  };

  config.deps = p:
    optionals cfg.enable [
      p.mkdocs-macros
      (p.buildPythonPackage {
        pname = "nixmkdocs_helpers";
        version = "latest";
        doCheck = false;
        dontUnpack = true;
        format = "other";
        src = ./macros_nixmkdocs_helpers.py;
        installPhase = ''
          mkdir -p $out/${p.python.sitePackages}/nixmkdocs_helpers
          cp $src $out/${p.python.sitePackages}/nixmkdocs_helpers/__init__.py
        '';
      })
    ];
  config.config.plugins = optional cfg.enable {
    macros = {
      include_dir = cfg.includeDir;
      render_by_default = cfg.renderByDefault;
      modules = ["nixmkdocs_helpers"];
    };
  };
}
