{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types optional;
  cfg = config.material;
in {
  options.material = {
    enable = mkEnableOption "mkdocs-material";
    colors = {
      primary = mkOption {
        type = types.str;
        default = "blue";
        description = ''
          Primary color.
        '';
      };
      accent = mkOption {
        type = types.str;
        default = "aqua";
        description = ''
          Accent color.
        '';
      };
    };
  };

  config.deps = p: optional (cfg.enable) p.mkdocs-material;
  config.config.edit_uri =
    if (cfg.enable)
    then "edit/${config.editBranch}${config.relPath}"
    else null;
  config.config.theme =
    if (cfg.enable)
    then {
      name = "material";
      features = ["content.code.copy" "content.action.edit"];
      palette = [
        {
          inherit (cfg.colors) primary accent;
          scheme = "default";
          media = "(prefers-color-scheme: light)";
          toggle = {
            icon = "material/brightness-7";
            name = "Switch to dark mode";
          };
        }
        {
          inherit (cfg.colors) primary accent;
          scheme = "slate";
          media = "(prefers-color-scheme: dark)";
          toggle = {
            icon = "material/brightness-4";
            name = "Switch to light mode";
          };
        }
      ];
    }
    else {};
  config.config.plugins = optional (cfg.enable) "search";
}
