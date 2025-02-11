{ pkgs, inputs, ... }:

{
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using zsh as our shell
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    _1password-gui
    teams-for-linux
    ghostty
    oci-cli
    monkeysphere
  ];

  users.users.cdenneen = {
    isNormalUser = true;
    home = "/home/cdenneen";
    extraGroups = [
      "docker"
      "lxd"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    hashedPassword = "$6$m57xh/c4gipjewT6$ovt9lGhsi.m6WHHUvrRYvbi8k63mSBnkxV3r2VNg9iJBL7sKYDGpovjDgk21cAmz44IOvwJek9eoytlEZGwi6/";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAyhU3OsKXxtks9hUrNTcdNqAjmI70oUCTt+/kYsFfe7WbOYtiMKObG74MWZkr0ylqmRoh8eh3PeIgnydjrr8nn0XwuaLmzUR66JhIBODDTP0QYe/X0IUg9oFRTFf1c+3moFAqDjU8wscDQZ5GGvzPLqwld0B7XCFDJ/kA79srmik5ZVtLOu1gckNi4cdEWkZiHAWEDy9o6GXpgRAYFAt1jU6zSIXCmYb02NHg/6oo+1oJVDQIQsjBOMsJE0Qh+erAmu+Y/nf59hE6K8Yvw7NMcrG+3MOFY2mrJmG9ZvL9u0EqZMlXFL373nYHOVjChzbuc+RVCEC116JHqi77A9a+Dw== cdenneen"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGI+qXu0T9JXSWpLv6Ia3blE/0ly2/8GwAreZRBxB2Hz id_ed25519"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1avpzyzr4rhp/LyD9JrcO+DJP+6pBMwbOglSBXHudF cdenneen_ed25519_2024"
    ];
  };

  nixpkgs.overlays = import ../../lib/overlays.nix;
}
