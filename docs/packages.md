# Generated Packages

For each documentation site configured using the [`docs`](options.md#docs) options, NixMkDocs generates two packages in your system's `legacyPackages` (or equivalent, depending on your `flake-parts` setup). The name of these packages is derived from the name given to the documentation entry (e.g., `"default"`, `"user-guide"`, `"api-docs"`).

Let's assume your documentation site is named `<name>`.

## `docs:<name>`

- **Type:** `derivation`
- **Description:** This package is a Nix derivation that builds the static HTML documentation site using the `mkdocs build` command. The output of this derivation is the fully built website, ready for deployment.
- **Usage:** You can build this package using `nix build .#docs:<name>` from the root of your project flake. Replace `<name>` with the actual name of your documentation site (e.g., `nix build .#docs:default`, `nix build .#docs:user-guide`).
  After a successful build, the generated documentation site will be available in the `result/` directory symlinked in your project root.

## `docs:<name>:watch`

- **Type:** `package` (executable shell script)
- **Description:** This package is an executable shell script that runs the `mkdocs serve` command for the specified documentation site. This command starts a local development web server that automatically reloads your browser whenever it detects changes in your documentation source files. It's ideal for previewing your documentation while you are writing it.
- **Usage:** You can run this package directly using `nix run .#docs:<name>:watch`. Replace `<name>` with the actual name of your documentation site (e.g., `nix run .#docs:default:watch`, `nix run .#docs:api-docs:watch`).
- **Technical Note:** The `watch` script attempts to determine the correct path to your documentation source directory (`docs_dir`). If the `$DEVENV_ROOT` environment variable is set (automatically set when using [devenv](https://devenv.sh)), it will use an absolute path based on `$DEVENV_ROOT` and the relative path of your `docs_dir` within the flake. Otherwise, it will use a relative path assuming you are running the command from the flake's root directory. Same thing with the `$PRJ_ROOT` env variable.

These packages provide a convenient workflow for both building your documentation for deployment and developing it locally with live previews.
