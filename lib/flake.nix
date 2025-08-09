{
  description = "NixMkDocs lib";

  outputs = {...}: {
    lib = import ./.;
    flakeModule = import ./flakeModule.nix;
  };
}
