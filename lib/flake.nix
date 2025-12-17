{
  description = "NixMkDocs lib";

  outputs = {...}: {
    lib = import ./.;
    flakeModule = ./flakeModule.nix;
  };
}
