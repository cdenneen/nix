{ config, inputs, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    arc-browser
    brave
    coreutils
    discord
    iina
    istatmenus
    itsycal
    keycastr
    maccy
    mas
    mkalias
    raycast
    rectangle
    slack
    ssm-session-manager-plugin
    stats
    synology-drive-client
  ];
  homebrew = {
    enable = true;
    brews = [
      "aws/tap/eks-node-viewer"
      "danielfoehrkn/switch/switch"
      "fluxcd/tap/flux"
    ];
    casks  = [
      "1password"
      "amazon-chime"
      "amazon-photos"
      "cleanshot"
      "evernote"
      "firefox@developer-edition"
      "fliqlo"
      "google-chrome"
      "hammerspoon"
      "hiddenbar"
      "imageoptim"
      "keybase"
      "jumpcut"
      "megasync"
      "microsoft-edge"
      "monodraw"
      "spotify"
    ];
    # masApps = {
    #   "1Password for Safari" = 1569813296;
    # };
    taps = [
      "aws/tap"
      "cdenneen/tap"
      "danielfoehrkn/switch"
      "env0/terratag"
      "fluxcd/tap"
      "puppetlabs/puppet"
    ];
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.cdenneen = {
    home = "/Users/cdenneen";
    shell = pkgs.zsh;
  };

  fonts.packages = [
    pkgs.nerdfonts
    pkgs.jetbrains-mono
  ];

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';
  system.defaults = {
    dock.autohide  = true;
    dock.largesize = 64;
    dock.persistent-apps = [
      "${pkgs.alacritty}/Applications/Alacritty.app"
      "${pkgs.kitty}/Applications/Kitty.app"
    ] ++ (lib.optionals) pkgs.stdenv.isAarch64 [
      "${pkgs.ghostty}/Applications/Ghostty.app"
    ] ++ [
      "/System/Applications/Messages.app"
      "/Applications/Safari.app"
      "/Applications/Firefox Developer Edition.app"
    ];
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled  = false;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
  };

  security.pam.enableSudoTouchIdAuth = true;
}
