{
  pkgs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    literalExpression
    concatMapAttrs
    removePrefix
    assertMsg
    ;
in rec {
  docsSubmodule = {
    name,
    config,
    ...
  }: {
    _file = ./module.nix;
    imports = [extraModules];
    options = {
      path = mkOption {
        type = types.either types.str types.path;
        default = "";
        description = ''
          Path to the docs.
        '';
      };
      base = mkOption {
        type = types.either types.str types.path;
        default = "";
        description = ''
          Base path of the repo (often the parent dir of the dir specified in `path`).
        '';
      };
      deps = mkOption {
        type = types.functionTo (types.listOf types.package);
        default = _p: [];
        defaultText = literalExpression "p: []";
        description = ''
          Dependencies needed to build the docs.
        '';
      };
      config = mkOption {
        type = let
          # from https://discourse.nixos.org/t/nix-function-to-merge-attributes-records-recursively-and-concatenate-arrays/2030/9
          deepMerge = lhs: rhs:
            lhs
            // rhs
            // (builtins.mapAttrs (
                rName: rValue: let
                  lValue = lhs.${rName} or null;
                in
                  if builtins.isAttrs lValue && builtins.isAttrs rValue
                  then deepMerge lValue rValue
                  else if builtins.isList lValue && builtins.isList rValue
                  then lValue ++ rValue
                  else rValue
              )
              rhs);
        in
          types.attrs
          // {
            merge = _loc: defs: lib.foldl' deepMerge {} (map (def: def.value) defs);
          };
        default = {};
        description = ''
          Configuration which gets passed to mkdocs.
        '';
      };

      # internal
      relPath = mkOption {
        internal = true;
        type = types.str;
      };
      finalConfig = mkOption {
        internal = true;
        type = types.attrs;
      };
      finalConfigYaml = mkOption {
        internal = true;
        type = types.package;
      };
      finalPackage = mkOption {
        internal = true;
        type = types.package;
      };
      watchPackage = mkOption {
        internal = true;
        type = types.package;
      };
    };
    config = let
      deps = pkgs.python3.withPackages config.deps;
    in rec {
      relPath = removePrefix (builtins.toString config.base) (builtins.toString config.path);
      finalConfig = assert assertMsg (config.path != "") "'path' for documentation entry '${name}' is unset";
        {
          docs_dir = config.path;
          site_name = name;
        }
        // config.config;
      finalConfigYaml = (pkgs.formats.yaml {}).generate "${name}-config.yaml" finalConfig;
      finalPackage = pkgs.stdenv.mkDerivation {
        name = "docs:${name}";
        PYTHONPATH = "${deps}/${deps.sitePackages}";
        phases = ["buildPhase"];
        buildInputs = [pkgs.mkdocs];
        buildPhase = ''
          mkdir -p $out
          mkdocs build -f ${finalConfigYaml} -d $out
        '';
      };
      watchPackage = pkgs.writeShellScriptBin "docs:${name}:watch" ''
        export PYTHONPATH="${deps}/${deps.sitePackages}";

        for root_var in REN_ROOT PRJ_ROOT DEVENV_ROOT; do
          if [ ! -z "''${!root_var}" ]; then
            doc_path="''${!root_var}${relPath}"
            echo "$root_var detected, using absolute path ($doc_path)"
            break
          fi
        done
        if [ -z "$doc_path" ]; then
          doc_path="$PWD${relPath}"
          echo "Using relative path .${relPath} (=$doc_path), make sure you are in the project root"
        fi
        tmp_config=$(mktemp)
        echo "{INHERIT: ${finalConfigYaml}, docs_dir: $doc_path}" > $tmp_config
        trap "rm -f $tmp_config" EXIT
        ${pkgs.mkdocs}/bin/mkdocs serve -f $tmp_config $@
      '';
    };
  };

  nixMkDocsSubmodule = {config, ...}: {
    _file = ./module.nix;
    options = {
      docs = mkOption {
        type = types.attrsOf (types.submodule docsSubmodule);
        default = {};
        description = ''
          Specify multiple docs by specifying them in an attrset.
        '';
      };

      packages = mkOption {
        internal = true;
        type = types.attrsOf types.package;
      };
    };
    config = {
      packages =
        concatMapAttrs (n: v: {
          "docs:${n}" = v.finalPackage;
          "docs:${n}:watch" = v.watchPackage;
        })
        config.docs;
    };
  };

  extraModules = ./modules;
}
