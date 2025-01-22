{ lib, pkgs, ... }:
with pkgs;
{
  programs.ghostty = {
    enable = true;
    package = ghostty;
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
