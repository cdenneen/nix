{
  pkgs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = !isWSL;
    extraConfig = builtins.readFile ./kitty;
  };
}
