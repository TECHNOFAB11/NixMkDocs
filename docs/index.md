# NixMkDocs

NixMkDocs is a Nix flake module designed to simplify the process of building documentation sites with MkDocs directly from your project's markdown files. It allows you to define your MkDocs configuration and dependencies within your Nix flake, providing reproducible documentation builds and convenient development workflows.

## Features

- **Reproducible Builds:** Define all your documentation dependencies (MkDocs plugins, themes, etc.) in Nix, ensuring consistent builds across different environments.
- **Nix-based Configuration:** Configure MkDocs using Nix attributes, allowing for dynamic or conditional configurations.
- **Multiple Documentation Sets:** Easily manage multiple documentation sites within a single project.
- **Development Server:** Includes a `watch` package for local development with live reloading.
- **Integration with `flake-parts`:** Designed as a `flake-parts` module for easy integration into existing projects.
