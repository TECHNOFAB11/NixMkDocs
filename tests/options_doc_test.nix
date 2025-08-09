{
  pkgs,
  doclib,
  ntlib,
  ...
}: {
  suites."Options Docs" = {
    pos = __curPos;
    tests = [
      {
        name = "simple option doc";
        type = "script";
        script = let
          optionsDoc = doclib.mkOptionDocs {
            module = doclib.modules.docsSubmodule;
          };
        in
          # sh
          ''
            ${ntlib.helpers.scriptHelpers}
            assert_file_contains ${optionsDoc} "### `config`"
            assert_file_contains ${optionsDoc} "/lib/module.nix"
          '';
      }
      {
        name = "root urls";
        type = "script";
        script = let
          optionsDoc = doclib.mkOptionDocs {
            module = doclib.modules.docsSubmodule;
            roots = [
              {
                url = "https://example.com";
                path = ../lib;
              }
            ];
          };
        in
          # sh
          ''
            ${ntlib.helpers.scriptHelpers}
            assert_file_contains ${optionsDoc} "https://example.com/module.nix"
          '';
      }
    ];
  };
}
