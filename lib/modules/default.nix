{lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./material.nix
    ./material-umami.nix
    ./macros.nix
    ./dynamic-nav.nix
  ];

  options.editBranch = mkOption {
    type = types.str;
    default = "main";
    description = ''
      Branch to link to/use when the user clicks on "Edit Page".
    '';
  };
}
