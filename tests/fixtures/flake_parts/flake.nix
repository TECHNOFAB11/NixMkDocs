{
  outputs = {
    flake-parts,
    systems,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        "@repo_path@/lib/flakeModule.nix"
      ];
      systems = import systems;
      flake = {};
      perSystem = _: {
        docs = {
          "default".config = {
            path = "@repo_path@/tests/fixtures/simple";
            config.theme = "mkdocs";
          };
          "material" = {
            path = "@repo_path@/tests/fixtures/simple";
            material.enable = true;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default-linux";
  };
}
