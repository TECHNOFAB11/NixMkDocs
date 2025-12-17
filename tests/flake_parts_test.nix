{
  pkgs,
  ntlib,
  ...
}: {
  suites."flake-parts" = {
    pos = __curPos;
    tests = [
      {
        name = "flakeModule";
        type = "script";
        script =
          # sh
          ''
            ${ntlib.helpers.scriptHelpers}
            ${ntlib.helpers.path (with pkgs; [coreutils nix gnused gnugrep jq])}
            export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
            export NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
            repo_path=${../.}

            cp ${./fixtures/flake_parts}/* .
            # import from the absolute path above, is easier than trying to figure out the repo path etc.
            sed -i -e "s|@repo_path@|$repo_path|" flake.nix

            # NOTE: --impure is required since importing modules from absolute paths is not allowed in pure mode
            nix build --impure .#docs:default
            assert "-f result/index.html" "index.html should exist"
            assert "-d result/js" "js dir should exist"

            nix build --impure .#docs:material
            assert "-f result/index.html" "index.html should exist"
            assert "! -d result/js" "no js dir for material"
            assert "-d result/assets" "assets dir for material"
            assert_file_contains "result/index.html" "mkdocs-material"
          '';
      }
    ];
  };
}
