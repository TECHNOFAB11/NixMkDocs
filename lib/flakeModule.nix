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
      inherit (lib) mkOption types;

      cfg = config.docs.config;
      docType = types.submodule {
        options = {
          path = mkOption {
            type = types.path;
            default = "";
            apply = op: toString op;
          };
          deps = mkOption {
            type = types.functionTo (types.listOf types.package);
            default = p: [];
          };
          config = mkOption {
            type = types.attrs;
            default = {};
          };
        };
      };
    in {
      options = {
        docs = mkOption {
          type = types.lazyAttrsOf docType;
          description = '''';
          default = {};
          apply = op: let
            # NOTE: show warning if "default" is set and config.doc is not {}
            legacyMode = config.doc != {};
            defaultExists = builtins.hasAttr "default" op;
            value =
              {
                "default" = config.doc;
              }
              // op;
          in
            if defaultExists && legacyMode
            then builtins.trace "Warning: config.doc is overwritten by docs.default" value
            else value;
        };
        doc = mkOption {
          type = docType;
          description = ''
            Note: this is a shorthand for writing `docs."default"`
          '';
          default = {};
        };
      };

      config.legacyPackages = lib.fold (doc: acc: acc // doc) {} (map (
        doc_name: let
          doc = builtins.getAttr doc_name config.docs;
          relPath = lib.removePrefix (toString self) (toString doc.path);

          deps = pkgs.python3.withPackages doc.deps;

          docConfig =
            {
              docs_dir = doc.path;
              site_name = doc_name;
            }
            // doc.config;
          configYaml = (pkgs.formats.yaml {}).generate "${doc_name}-config.yaml" docConfig;
        in
          assert lib.assertMsg (doc.path != "") "'path' for documentation entry '${doc_name}' is unset ${doc.path}"; {
            # build
            "docs:${doc_name}" = pkgs.runCommand "docs:${doc_name}" {} ''
              export PYTHONPATH="${deps}/${deps.sitePackages}";
              mkdir -p $out
              ${pkgs.mkdocs}/bin/mkdocs build -f ${configYaml} -d $out
            '';
            # watch
            "docs:${doc_name}:watch" = pkgs.writeShellScriptBin "docs:${doc_name}:watch" ''
              export PYTHONPATH="${deps}/${deps.sitePackages}";
              if [ -z "$DEVENV_ROOT" ]; then
                doc_path=".${relPath}"
                echo "No devenv detected, using relative path ($doc_path), make sure you are in the project root"
              else
                doc_path="$DEVENV_ROOT${relPath}"
                echo "Devenv detected, using absolute path ($doc_path)"
              fi
              tmp_config=$(mktemp)
              echo "{INHERIT: ${configYaml}, docs_dir: $doc_path}" > $tmp_config
              trap "rm -f $tmp_config" EXIT
              ${pkgs.mkdocs}/bin/mkdocs serve -f $tmp_config
            '';
          }
      ) (builtins.attrNames config.docs));
    }
  );
}
