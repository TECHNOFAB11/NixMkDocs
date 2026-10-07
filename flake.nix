{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ren.url = "gitlab:rensa-nix/core/v0.2.1?dir=lib";
  };

  outputs = {
    self,
    ren,
    ...
  } @ inputs:
    ren.buildWith
    {
      inherit inputs;
      cellsFrom = ./nix;
      transformInputs = system: i:
        i
        // {
          pkgs = import i.nixpkgs {inherit system;};
        };
    }
    {
      packages = ren.select self [
        ["repo" "ci" "packages"]
        ["repo" "docs"]
        ["repo" "soonix" "packages"]
        ["repo" "tests"]
      ];
    };
}
