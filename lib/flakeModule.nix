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
          description = '''';
          default = {};
        };
        # WARN: see below
        # doc = mkOption {
        #   type = types.submodule doclib.modules.docsSubmodule;
        #   description = ''
        #     Note: this is a shorthand for writing `docs."default"`
        #   '';
        #   default = {};
        # };
      };

      # WARN: janky af, removed for now, just not worth it
      #   details: with the modules, mkDefault basically results in any user config
      #            being "default" and thus overriden by the modules
      # config.docs."default".config = mkDefault config.doc;

      config.legacyPackages =
        concatMapAttrs (n: v: {
          "docs:${n}" = v.finalPackage;
          "docs:${n}:watch" = v.watchPackage;
        })
        config.docs;
    }
  );
}
