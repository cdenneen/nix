{ config, pkgs, lib, currentSystem, currentSystemName,... }: {
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  # Remote desktop
  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.gnome.gnome-session}/bin/gnome-session";
    openFirewall = true;
  };

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled.
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
