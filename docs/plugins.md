# Plugins

NixMkDocs' module now includes wrappers/abstractions over some MkDocs plugins.

## [`mkdocs-material`](https://github.com/squidfunk/mkdocs-material)

**Example**:

```nix
material = {
  enable = true;
  colors = {
    primary = "indigo"; # mkdocs-material colors
    accent = "blue";
  };
};
```

For all options see [Options](./options.md#docsnamematerialenable).

## [`mkdocs-macros`](https://github.com/fralau/mkdocs-macros-plugin)

**Example**:

```nix
macros = {
  enable = true;
  includeDir = ./some_includes;  # directory where "include" will look for files
};
```

For all options see [Options](./options.md#docsnamemacrosenable).

## [`mkdocs-material-umami`](https://gitlab.com/TECHNOFAB/mkdocs-material-umami)

**Example**:

```nix
material.umami = {
  enable = true;
  src = "https://umami.example.com/umami";
  siteId = "UUID of site";
  domains = ["myproject.example.com"];
};
```

For all options see [Options](./options.md#docsnamematerialumamienable).

## [`mkdocs-dynamic-nav`](https://gitlab.com/TECHNOFAB/mkdocs-dynamic-nav)

**Example**:

```nix
dynamic-nav = {
  enable = true;
  files."Dynamic Nav Plugin" = [
    {"Look im below E!" = builtins.toFile "test.md" "This is generated from Nix and the order works!";}
    {"Example Entry" = builtins.toFile "test.md" "Hello from Nix!";}
  ];
};
```

For all options see [Options](./options.md#docsnamedynamic-navenable).
