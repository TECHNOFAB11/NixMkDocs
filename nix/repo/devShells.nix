{
  cell,
  inputs,
  ...
}: let
  inherit (inputs) pkgs devshell treefmt devtools-lib;
  inherit (cell) soonix;
  treefmtWrapper = treefmt.mkWrapper pkgs {
    programs = {
      alejandra.enable = true;
      deadnix.enable = true;
      statix.enable = true;
      mdformat.enable = true;
    };
    settings.formatter.mdformat = {
      command = let
        pkg = pkgs.python3.withPackages (p: [
          p.mdformat
          p.mdformat-mkdocs
        ]);
      in "${pkg}/bin/mdformat";
      excludes = [
        "CHANGELOG.md"
        "*LICENSE*.md"
      ];
    };
  };
in {
  default = devshell.mkShell {
    imports = [soonix.devshellModule devtools-lib.devshellModule];
    packages = [
      pkgs.nil
      treefmtWrapper
    ];
    lefthook.config = {
      "pre-commit" = {
        parallel = true;
        jobs = [
          {
            name = "treefmt";
            stage_fixed = true;
            run = "${treefmtWrapper}/bin/treefmt";
            env.TERM = "dumb";
          }
          {
            name = "soonix";
            stage_fixed = true;
            run = "nix run .#soonix:update";
          }
        ];
      };
    };
    cocogitto.config = {
      tag_prefix = "v";
      ignore_merge_commits = true;
      changelog = {
        authors = [
          {
            username = "TECHNOFAB";
            signature = "technofab";
          }
        ];
        path = "CHANGELOG.md";
        template = "remote";
        remote = "gitlab.com";
        repository = "nixmkdocs";
        owner = "TECHNOFAB";
      };
    };
  };
}
