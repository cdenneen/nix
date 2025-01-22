{ lib, pkgs, ghostty, ... }:
with pkgs;
let
  isDarwin = stdenv.isDarwin;
in
{
  programs.ghostty = {
    enable = ghostty;
    package = if isDarwin then null else pkgs.ghostty;
  };

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
