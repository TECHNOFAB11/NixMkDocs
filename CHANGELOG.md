# Changelog
All notable changes to this project will be documented in this file. See [conventional commits](https://www.conventionalcommits.org/) for commit guidelines.

- - -
## [v1.1.0](https://gitlab.com/TECHNOFAB/nixmkdocs/compare/747d1ce04f56dcfe003bb64b8f654abc4f5c5f2a..v1.1.0) - 2026-01-04
#### Features
- (**macros**) extend options and add helper package to include files - ([9ac8c53](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/9ac8c5345fea35fd8d191c6960fbdd88fafb55e9)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- (**module**) improve module and packaging, use mkDerivation f.ex. - ([8f683cd](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/8f683cdbfc0af3c0044f6d3ac422f92459ba3e4a)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- switch from flake-parts & devenv to rensa - ([0c7697a](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/0c7697a7b3f0e476f408e8e8d7720deb0d42a03f)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- add dynamic-nav plugin - ([73d5909](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/73d59093df94a894d25bc4bf71880b6f00faa62f)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- add edit button options - ([ebb795a](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/ebb795a0fa02d1e7e11848f911f04ae65f7432e0)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- add modules for some plugins - ([4fd5a35](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/4fd5a351c54e005c4e8df7e23a8e4eec9d3b8cd1)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
#### Bug Fixes
- (**material-umami**) wrong config path - ([7840a5f](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/7840a5febdbeaf2da90babf6c94b3d0929d2bf74)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- (**module**) switch back to tmpfile, file descriptors & hot reload no good - ([cb0bb5d](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/cb0bb5dc3382e8ba5d81324a2f1fd94ccd5a5df4)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- (**module**) only toString path when required, should fix dir not found - ([e16c2e6](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/e16c2e6f1f8074d0b9f9101271e125233d5c09fc)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- use $PWD for relative path and fix wrong URL in options docs - ([c4697ce](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/c4697ce721e17fa2de81375e4146e7dd5769deef)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
#### Documentation
- improve docs, descriptions, logo etc. - ([c6e22e4](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/c6e22e4bf88df94283bf461e0b8fd2c851ea8b39)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- improve docs, descriptions, logo etc. - ([cb82aee](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/cb82aeeaef1f066fadd69379baccfabb7b9eea52)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- remove references to doc shorthand - ([61da605](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/61da605a9bff12f66c4b743f43aea59ca200f533)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
#### Miscellaneous Chores
- (**deps**) lock file maintenance - ([1512a68](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/1512a68bfb57a99b954dd454c8ded56fd0fc3030)) - Renovate Bot
- (**module**) forward cli params to mkdocs - ([ae559bb](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/ae559bb80ec3a4b2c9eb27b75e7b45f8b5853fdb)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- (**optionsDocs**) add error context for easier debugging - ([3b41744](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/3b41744277f0a650bfc22cd656412afbda89d36d)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- add devtools - ([c8e1295](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/c8e129546b9ed50b92059577c2a89a1e7359c1bb)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- default lib to pkgs.lib - ([4dbffce](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/4dbffced1abf42fa1bf47890c951d3835f2fc608)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- add LICENSE - ([8d0a6ce](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/8d0a6ce2de1ca187a43ac6d638c1a84aa75f8947)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- improve README and other minor improvements - ([747d1ce](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/747d1ce04f56dcfe003bb64b8f654abc4f5c5f2a)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)

- - -

## [v1.0.0](https://gitlab.com/TECHNOFAB/nixmkdocs/compare/v0.1.0..v1.0.0) - 2026-01-04
#### Refactoring
- use nix modules to generalize lib - ([1e1f859](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/1e1f859d8faf4bceee77863586fbcac2909f274b)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)

- - -

## [v0.1.0](https://gitlab.com/TECHNOFAB/nixmkdocs/compare/defe88ce84e20b122a806ba2f4fde8b329c07e28..v0.1.0) - 2026-01-04
#### Bug Fixes
- (**CI**) copy correctly - ([6d6e013](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/6d6e0139060c896ae14de4b9c82335655a384643)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- (**CI**) typo - ([0ec5495](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/0ec54957834a4b70936d0fc70a61afdfc206d08c)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
#### Documentation
- only send analytics on correct domain - ([c7e3c3b](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/c7e3c3b13ded25818e9789938387bba6f2cde690)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- write basic documentation and improve mkdocs site - ([6c4bff3](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/6c4bff339003ab0197a6dda96eea847996f21a63)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
#### Continuous Integration
- disable nix-ci for pages - ([ac3adf5](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/ac3adf5c0d6a6345c332b44681e827877fa15dac)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
#### Miscellaneous Chores
- add CI - ([a11d536](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/a11d536e21d17f334a4060956d15aaaeb450906c)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)
- initial commit - ([defe88c](https://gitlab.com/TECHNOFAB/nixmkdocs/commit/defe88ce84e20b122a806ba2f4fde8b329c07e28)) - [@TECHNOFAB](https://gitlab.com/TECHNOFAB)

- - -

Changelog generated by [cocogitto](https://github.com/cocogitto/cocogitto).
