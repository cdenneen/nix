{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/virtualisation/amazon-image.nix")
    ./vm-shared-ec2.nix
  ];
  ec2.efi = true;

  services.udisks2.enable = lib.mkForce false;
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";

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
