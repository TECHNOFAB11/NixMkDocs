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
    recursiveUpdate
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
        apply = op: toString op;
        description = "Path to the docs";
      };
      base = mkOption {
        type = types.either types.str types.path;
        default = "";
        apply = op: toString op;
        description = ''
          Base path of the repo (parent dir of the dir specified in `path`)
        '';
      };
      deps = mkOption {
        type = types.functionTo (types.listOf types.package);
        default = p: [];
        defaultText = literalExpression "p: []";
        description = "Dependencies needed to build the docs";
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
            merge = loc: defs: lib.foldl' deepMerge {} (map (def: def.value) defs);
          };
        default = {};
        description = "Configuration which gets passed to mkdocs";
      };

      # internal
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
      relPath = removePrefix (config.base) (config.path);
    in {
      finalConfig = assert assertMsg (config.path != "") "'path' for documentation entry '${name}' is unset";
        {
          docs_dir = config.path;
          site_name = name;
        }
        // config.config;
      finalConfigYaml = (pkgs.formats.yaml {}).generate "${name}-config.yaml" config.finalConfig;
      finalPackage = pkgs.runCommand "docs:${name}" {} ''
        export PYTHONPATH="${deps}/${deps.sitePackages}";
        mkdir -p $out
        ${pkgs.mkdocs}/bin/mkdocs build -f ${config.finalConfigYaml} -d $out
      '';
      watchPackage = pkgs.writeShellScriptBin "docs:${name}:watch" ''
        export PYTHONPATH="${deps}/${deps.sitePackages}";
        if [ ! -z "$DEVENV_ROOT" ]; then
          doc_path="$DEVENV_ROOT${relPath}"
          echo "DEVENV_ROOT detected, using absolute path ($doc_path)"
        elif [ ! -z "$PRJ_ROOT" ]; then
          doc_path="$PRJ_ROOT${relPath}"
          echo "PRJ_ROOT detected, using absolute path ($doc_path)"
        else
          doc_path=".${relPath}"
          echo "Using relative path ($doc_path), make sure you are in the project root"
        fi
        tmp_config=$(mktemp)
        echo "{INHERIT: ${config.finalConfigYaml}, docs_dir: $doc_path}" > $tmp_config
        trap "rm -f $tmp_config" EXIT
        ${pkgs.mkdocs}/bin/mkdocs serve -f $tmp_config
      '';
    };
  };

  nixMkDocsSubmodule = {config, ...}: {
    _file = ./module.nix;
    options = {
      docs = mkOption {
        type = types.attrsOf (types.submodule docsSubmodule);
        default = {};
        description = "Specify multiple docs by specifying them in an attrset";
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
