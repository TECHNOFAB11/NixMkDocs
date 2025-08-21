# Examples

Here are some examples demonstrating how to configure your documentation sites using NixMkDocs.

## Basic Usage

This example shows how to configure a single documentation site:

```nix
# in your perSystem config in flake.nix:
#                .- required because the module system otherwises confuses it with the "config" below
docs."default".config = {
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

## Usage for multiple sites

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

## More examples

See this project's flake for usage of modules for example.
