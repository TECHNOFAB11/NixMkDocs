{
  flake-parts-lib,
  lib,
  self,
  ...
}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    {
      config,
      pkgs,
      ...
    }: let
      inherit (lib) mkOption types concatMapAttrs;
      doclib = import ./. {inherit lib pkgs;};
    in {
      options = {
        docs = mkOption {
          type = types.attrsOf (types.submoduleWith {
            modules = [
              doclib.modules.docsSubmodule
              {
                config.base = builtins.toString self;
              }
            ];
          });
          description = ''
            Define your docs sites here.
          '';
          default = {};
        };
      };

      config.legacyPackages =
        concatMapAttrs (n: v: {
          "docs:${n}" = v.finalPackage;
          "docs:${n}:watch" = v.watchPackage;
        })
        config.docs;
    }
  );
}
