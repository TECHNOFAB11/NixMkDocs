{
  description = "NixMkDocs lib";

  outputs = {...}: {
    flakeModule = import ./flakeModule.nix;
  };
}
