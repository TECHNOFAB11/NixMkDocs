{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types optional;
  cfg = config.macros;
in {
  options.macros = {
    enable = mkEnableOption "mkdocs-macros";
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
  };

  config.deps = p: optional (cfg.enable) p.mkdocs-macros;
  config.config.plugins = optional (cfg.enable) {
    macros.include_dir = cfg.includeDir;
  };
}
