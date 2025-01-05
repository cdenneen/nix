{
  inputs,
  isWSL,
  ...
}:
{
  programs.i3status = {
    enable = isLinux && !isWSL;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };
}
