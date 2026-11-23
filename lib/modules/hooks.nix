{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkOption types optional;
  cfg = config.hooks;
in {
  options.hooks = {
    nix-store-image-rewrite.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to add a hook which rewrites nix store paths,
        allowing you to easily include nix store paths in the documentation
        without mkdocs treating it as absolute path and not including it.
      '';
    };
  };
  config.config.hooks = optional cfg.nix-store-image-rewrite.enable (pkgs.writeText "nix_store_image_rewriter.py"
    # py
    ''
      import os
      import re
      import shutil
      from mkdocs.utils import log

      # Regex to detect any image paths originating from the Nix store
      NIX_STORE_REGEX = re.compile(r'src="(/nix/store/[^"]+)"')

      def on_page_content(html, page, config, files):
          site_dir = config['site_dir']
          # We will place all extracted images into site/assets/nix-images/
          target_sub_dir = os.path.join("assets", "nix-images")
          output_dir = os.path.join(site_dir, target_sub_dir)

          def replace_nix_path(match):
              absolute_nix_path = match.group(1)

              if not os.path.exists(absolute_nix_path):
                  log.error(f"Nix store image path does not exist: {absolute_nix_path}")
                  return match.group(0)
              # Split '/nix/store/h16p6i...-filename.png' into pieces
              path_parts = absolute_nix_path.strip('/').split('/')
              store_dir_name = path_parts[2]

              if len(store_dir_name) > 32 and store_dir_name[32] == '-':
                  nix_hash = store_dir_name[:32]
                  base_filename = os.path.basename(absolute_nix_path)
                  unique_filename = f"{nix_hash}-{base_filename}"
              else:
                  raise RuntimeError(f"{store_dir_name} is malformed?")

              os.makedirs(output_dir, exist_ok=True)
              shutil.copy2(absolute_nix_path, os.path.join(output_dir, unique_filename))

              # Calculate the relative path from the current page to the new asset location
              page_depth = len(page.url.strip('/').split('/')) if page.url.strip('/') else 0
              relative_prefix = "../" * page_depth if page_depth > 0 else ""

              new_src_path = f"{relative_prefix}{target_sub_dir}/{unique_filename}"
              return f'src="{new_src_path}"'

          return NIX_STORE_REGEX.sub(replace_nix_path, html)
    '');
}
