{
  doclib,
  ntlib,
  ...
}: {
  suites."Module" = {
    pos = __curPos;
    tests = [
      {
        name = "simple doc";
        type = "script";
        script = let
          doc = doclib.mkDocs {
            docs."test" = {
              path = ./fixtures/simple;
              config = {};
            };
          };
          build = doc.packages."docs:test";
          watcher = doc.packages."docs:test:watch" + "/bin/docs:test:watch";
        in
          # sh
          ''
            ${ntlib.helpers.scriptHelpers}
            # building
            assert "-f ${build}/sitemap.xml" "sitemap should exist"
            assert "-f ${build}/index.html" "index.html should exist"
            assert "-d ${build}/css" "css dir should exist"
            assert_file_contains ${build}/index.html "Hello world"

            # watching
            assert_file_contains ${watcher} "INHERIT:"
            assert_file_contains ${watcher} "docs_dir: \$doc_path"
            assert_file_contains ${watcher} "/bin/mkdocs serve -f"
          '';
      }
    ];
  };
}
