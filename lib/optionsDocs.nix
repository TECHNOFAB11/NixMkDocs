{
  lib,
  pkgs,
  roots ? [],
  module ? null,
  options ? null,
  transformOptions ? opt: opt,
  filter ? _: true,
  headingDepth ? 3,
  ...
}: let
  inherit
    (lib)
    findFirst
    hasPrefix
    evalModules
    removePrefix
    removeSuffix
    optionalString
    concatStringsSep
    mapAttrsToList
    concatStrings
    replicate
    ;
  inherit (pkgs) nixosOptionsDoc;

  rootsWithPrefixes = map (p: p // {prefix = "${toString p.path}/";}) roots;
  wrapDeclarations = decl: let
    root = findFirst (x: hasPrefix x.prefix decl) null rootsWithPrefixes;
  in
    if root == null
    then {
      path = builtins.unsafeDiscardStringContext (builtins.toString decl);
      url = "";
    }
    else rec {
      path = removePrefix root.prefix decl;
      url = "${root.url}/${path}";
    };

  # evaluate options if module is not null
  eval = evalModules {
    prefix = ["config"];
    modules = [
      {
        _module.check = false;
      }
      module
    ];
  };
  # generate our docs
  optionsDoc = nixosOptionsDoc {
    options =
      if options != null
      then options
      else eval.options;
    transformOptions = opt:
      transformOptions (opt
        // {
          visible = let
            filtered = !builtins.elem (builtins.head opt.loc) ["_module"];
          in
            filtered && opt.visible && (filter opt);
          name = removePrefix "config." opt.name;
          declarations = map wrapDeclarations opt.declarations;
        });
  };
  optToMd = opt: let
    headingDecl = concatStrings (replicate headingDepth "#");
  in
    ''
      ${headingDecl} `${opt.name}`

      ${
        if opt.description != null
        then opt.description
        else "(no description)"
      }

      **Type**:

      ```console
      ${opt.type}
      ```
    ''
    + (optionalString (opt ? default && opt.default != null) ''

      **Default value**:

      ```nix
      ${removeSuffix "\n" opt.default.text}
      ```
    '')
    + (optionalString (opt ? example) ''

      **Example value**:

      ```nix
      ${removeSuffix "\n" opt.example.text}
      ```
    '')
    + (
      optionalString (builtins.length opt.declarations > 0) ''

        **Declared in**:

      ''
      + (concatStringsSep "\n" (map (decl: "- [${decl.path}](${decl.url})") opt.declarations))
    )
    + "\n";

  opts = mapAttrsToList (name: opt:
    optToMd (opt
      // {
        inherit name;
      }))
  optionsDoc.optionsNix;
  markdown = concatStringsSep "\n" opts;
in
  builtins.toFile "options-doc.md" markdown
