# Examples

Here are some examples demonstrating how to configure your documentation sites using NixMkDocs.

## Basic Usage with `doc`

This example shows how to configure a single documentation site using the `doc` option, which is a shorthand for `docs."default"`.

```nix
# in your perSystem config in flake.nix:
doc = {
  path = ./docs; # Path to your documentation source files (e.g., your markdown files)
  deps = pp: [
    pp.mkdocs-material # Add the mkdocs-material theme as a dependency
    # Add other MkDocs plugins or themes here, e.g., pp.mkdocs-awesome-pages-plugin
  ];
  config = {
    site_name = "My Project Documentation"; # Explicitly set the site name
    theme.name = "material"; # Use the material theme
    nav = [ # Define your navigation structure
      { Home = "index.md"; }
      { "Getting Started" = "getting-started.md"; }
      { API = "api.md"; }
    ];
    # Add any other standard mkdocs.yml options here
    markdown_extensions = [
      "admonition"
      "pymdownx.highlight"
      "pymdownx.superfences"
    ];
  };
};
```

This configuration will create packages named `docs:default` and `docs:default:watch`.

## Usage with `docs` for multiple sites

This example shows how to configure multiple distinct documentation sites within the same project using the `docs` option.

```nix
# in your perSystem config in flake.nix:
docs = {
  "user-guide" = {
    path = ./user-guide; # Source files for the user guide
    deps = pp: [ pp.mkdocs-material ];
    config = {
      site_name = "User Guide";
      theme.name = "material";
      nav = [ { Introduction = "index.md"; } ];
      # Specific config for user guide
    };
  };
  "api-docs" = {
    path = ./api; # Source files for the API documentation
    deps = pp: [
      pp.mkdocs-material
      pp.mkdocs-swagger-ui-plugin # Example plugin dependency
    ];
    config = {
      site_name = "API Documentation";
      plugins = [
        "swagger-ui" # Enable the swagger-ui plugin
        # Other plugins...
      ];
      # Specific config for API docs
    };
  };
  # You can also include a "default" site here if needed
  "default" = {
    path = ./general-docs;
    config.site_name = "Project Docs";
  };
};
```

This configuration will create packages for each defined documentation set:

- `docs:user-guide` and `docs:user-guide:watch`
- `docs:api-docs` and `docs:api-docs:watch`
- `docs:default` and `docs:default:watch`

## Combining `doc` and `docs` (with caution)

You technically can use both `doc` and `docs` in your configuration. However, as mentioned in the [Configuration section](https://www.google.com/search?q=configuration.md), the `doc` option is just a shorthand for `docs."default"`. If you define both, the configuration specified under `docs."default"` will overwrite the configuration under `doc`, and a warning will be printed during evaluation.

It is generally recommended to choose one approach:

- Use `doc` if you *only* have a single documentation site and don't plan to add more named sites later.
- Use `docs` (and potentially define a `"default"` entry within it) if you have, or anticipate having, multiple documentation sites.

```nix
# in your perSystem config in flake.nix:
# NOTE: This configuration will cause docs."default" to overwrite doc
doc = {
  path = ./docs-legacy;
  config.site_name = "Legacy Docs (Will be overwritten)";
};

docs = {
  "default" = { # This configuration will be used for docs:default
    path = ./docs-new;
    config.site_name = "New Default Docs";
  };
  "another-set" = {
    path = ./docs-another;
    config.site_name = "Another Docs Set";
  };
};
```

In this scenario, the `docs:default` and `docs:default:watch` packages will be built using the configuration from `docs."default"` (path `./docs-new`, site name "New Default Docs"). The `docs:another-set` and `docs:another-set:watch` packages will use the configuration from `docs."another-set"`. The configuration provided under `doc` will be ignored for the `"default"` site.
