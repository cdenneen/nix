{ config, pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/virtualization/amazon-image.nix")
    ./vm-shared.nix
  ];

  # Interface is this on my EC2
  networking.interfaces.ens5.useDHCP = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "cdenneen";
  #
  # # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;
}
