{
  pkgs,
  lib ? pkgs.lib,
  ...
}: let
  inherit (lib) evalModules;
in rec {
  modules = import ./module.nix {inherit pkgs lib;};
  mkDocs = config:
    (evalModules {
      modules = [
        modules.nixMkDocsSubmodule
        {
          inherit config;
        }
      ];
    })
    .config;
  mkOptionDocs = {
    roots ? [],
    module ? null,
    options ? null,
    transformOptions ? opt: opt,
    filter ? _: true,
    headingDepth ? 3,
  }:
    import ./optionsDocs.nix {
      inherit lib pkgs roots module options transformOptions filter headingDepth;
    };
}
