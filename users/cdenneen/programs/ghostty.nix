{ lib, pkgs, ghostty, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  programs.ghostty = {
    enable = ghostty;
  } // (lib.optionalAttrs (!isDarwin) {
    package = pkgs.ghostty;
  });

  # config = mkIf cfg.enable {
  #   xdg.configFile."ghostty/config" = {
  #     text = ''
  #       font-family = "PragmataPro Mono Liga"
  #       font-size = 19
  #       theme = "nord"
  #       window-vsync = false
  #       window-decoration = false
  #     '';
  #   };
  # };
}
