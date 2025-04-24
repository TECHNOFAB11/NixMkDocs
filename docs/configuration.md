# Configuration

NixMkDocs provides options under `perSystem` to configure your documentation sites. These options allow you to specify the location of your source files, dependencies, and MkDocs configuration.

## `docs`

This option allows you to define multiple documentation sites. It is an attrset where each key represents the name of a documentation site, and the value is a configuration object for that site.

- **Type:** `types.lazyAttrsOf docType`
- **Default:** `{}`
- **Description:** An attribute set defining multiple documentation sites. The attribute name (the key in the attrset) is used as the name for the generated packages (e.g., `docs:my-docs`) and serves as the default `site_name` in the MkDocs configuration for that specific documentation set.

## `doc`

This option is a shorthand for defining a single documentation site named `"default"`. It's provided for convenience when you only have one set of documentation and prefer a simpler syntax.

- **Type:** `docType`
- **Default:** `{}`
- **Description:** Configuration for a single documentation site named `"default"`. This is functionally equivalent to setting `docs."default" = { ... };`.
- **Note:** If you define both `doc` and `docs."default"`, the value set in `docs."default"` will take precedence and overwrite the configuration in `doc`. A warning message will be displayed during evaluation in this case. It is recommended to use either `doc` for a single site or `docs` (potentially with a `"default"` key) for one or more sites.

## `docType` Configuration Object

Both `docs.<name>` and `doc` accept a configuration object with the following options. These options control the source of the documentation, its dependencies, and the specific MkDocs settings.

### `path`

- **Type:** `types.path`
- **Default:** `""`
- **Description:** The absolute or relative path to the directory containing your markdown documentation files (this corresponds to MkDocs' `docs_dir`). This option is **required**. An assertion will fail if this path is not specified for a documentation entry.

### `deps`

- **Type:** `types.functionTo (types.listOf types.package)`
- **Default:** `p: []`
- **Description:** A function that takes the Python packages attribute set (`pkgs.python3.withPackages`) as an argument (`p`) and returns a list of Python packages required for building your documentation. This is where you list MkDocs themes, plugins, or any other Python dependencies needed by your documentation build.

### `config`

- **Type:** `types.attrs`
- **Default:** `{}`
- **Description:** An attribute set representing the content of your `mkdocs.yml` configuration file. The options you define here will be merged with a base configuration provided by NixMkDocs (which automatically sets `docs_dir` based on the `path` option and `site_name` based on the documentation entry's name). You can define all standard MkDocs configuration options here as Nix attributes. Refer to the [MkDocs documentation](https://www.mkdocs.org/user-guide/configuration/) for available options.

See the [Examples section](examples.md) for practical demonstrations of how to use these configuration options.
