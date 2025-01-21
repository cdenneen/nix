{ config, pkgs, modulesPath, ... }: {
  imports = [
    ./hardware/vm-aarch64-utm.nix
    ./vm-shared.nix
  ];

  # Interface is this on my M1
  # networking.interfaces.enp0s1.useDHCP = true;

  # Qemu
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # For now, we need this since hardware acceleration does not work.
  environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "cdenneen";
  #
  # # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
