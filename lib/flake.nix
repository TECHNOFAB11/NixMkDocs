{
  description = "NixMkDocs lib";

  outputs = _: {
    lib = import ./.;
    flakeModule = ./flakeModule.nix;
  };
}
