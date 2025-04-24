# Getting Started

To use NixMkDocs, you need to include it in your flake's inputs and apply it as a module in your `flake-parts` configuration.

## 1. Add `nix-mkdocs` to your flake inputs

Open your `flake.nix` and add `nix-mkdocs` to the `inputs` section.

```nix
# flake.nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Or your preferred nixpkgs
  flake-parts.url = "github:hercules-ci/flake-parts";
  nix-mkdocs.url = "gitlab:TECHNOFAB/nixmkdocs?dir=lib";
};
```

## 2. Apply the module in your `flake-parts` configuration

Include `nix-mkdocs.flakeModule` in the `imports` list within your `flake-parts.lib.mkFlake` call:

```nix
# flake.nix
outputs = { flake-parts, ... }@inputs:
 flake-parts.lib.mkFlake {inherit inputs;} {
   imports = [
     inputs.nix-mkdocs.flakeModule
   ];
   systems = ...;
   flake = {};
   perSystem = {
     ...
   }: # etc.
```

Once you have included and applied the module, you can configure your documentation sites using the options described in the [Configuration section](configuration.md).
