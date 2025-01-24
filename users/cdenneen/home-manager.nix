{ config, lib, pkgs, inputs, isWSL, ghostty, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
    '' else ''
    cat "$1" | col -bx | bat --language man --style plain
  ''));

  homeDirectory = config.home.homeDirectory;
in {
  # Home-manager 22.11 requires this be set. We never set it so we have
  # to use the old state version.
  home.stateVersion = "18.09";

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs._1password-cli
    pkgs.asciinema
    pkgs.atuin
    pkgs.autojump
    pkgs.bat
    pkgs.cargo
    pkgs.direnv
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.gcc
    pkgs.gh
    pkgs.go
    pkgs.htop
    pkgs.jq
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubeswitch
    pkgs.lazygit
    pkgs.lua-language-server
    pkgs.mysql84
    pkgs.neovim
    pkgs.ripgrep
    pkgs.ruby
    pkgs.sentry-cli
    pkgs.sesh
    pkgs.shellcheck
    pkgs.terraform
    pkgs.terragrunt
    pkgs.thefuck
    pkgs.tmux
    pkgs.tree
    pkgs.unzip
    pkgs.watch

    # Node is required for Copilot.vim
    pkgs.nodejs
  ] ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    pkgs.cachix
    pkgs.tailscale
  ]) ++ (lib.optionals (isLinux && !isWSL) [
    pkgs.chromium
    pkgs.firefox
    pkgs.rofi
    pkgs.zathura
    pkgs.xfce.xfce4-terminal
  ]);

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "${manpager}/bin/manpager";
    DIRENV_WARN_TIMEOUT = "100s";
    MUTTER_DEBUG_KMS_THREAD_TYPE="user";
  };

  home.file = {
    ".kube/switch-config.yaml".source = ./switch-config.yaml;
    ".local/bin".source = ./bin;
  } // (lib.optionalAttrs isDarwin {
    "Library/Application Support/jj/config.toml".source = ./jujutsu.toml;
  });

  xdg.configFile = {
    "direnv/lib/k8s_context.sh".text = builtins.readFile ./programs/k8s_context.sh;
    "zsh".source = ./zsh;
    "i3/config".text = builtins.readFile ./i3;
    "rofi/config.rasi".text = builtins.readFile ./rofi;

    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/src/personal/nvimlocal";
    # "nvim".source = builtins.fetchGit {
    #   url = "https://github.com/cdenneen/nvim";
    #   rev = "5777e58132ee21cb6e04f29b163d56b28306c80c";
    #   ref = "main";
    #   allRefs = true;
    # };
  } // (lib.optionalAttrs isDarwin {
    # Rectangle.app. This has to be imported manually using the app.
    "rectangle/RectangleConfig.json".text = builtins.readFile ./RectangleConfig.json;
  }) // (lib.optionalAttrs isLinux {
    "ghostty/config".text = builtins.readFile ./ghostty.linux;
    "jj/config.toml".source = ./jujutsu.toml;
  });

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  imports = [
    ./gnupg.nix
    ./programs/alacritty.nix
    ./programs/awscli.nix
    ./programs/bash.nix
    ./programs/direnv.nix
    ./programs/eza.nix
    ./programs/fzf.nix
    # ./programs/ghostty.nix
    # ./programs/gpg.nix # moved to gnupg.nix
    ./programs/git.nix
    ./programs/i3status.nix
    ./programs/jujutsu.nix
    # ./programs/keychain.nix # moved to gnupg.nix
    ./programs/kitty.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ];

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
    gtk.enable = true;
  };

  sops = {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = "${inputs.self}/users/cdenneen/secrets/secret.yaml";
    validateSopsFiles = false;
  };

  sops.secrets = {
    "fortress_rsa" = {
      path = "${homeDirectory}/.ssh/id_rsa.fortress";
      mode = "0400";
    };
    "cdenneen_ed25519_2024" = {
      path = "${homeDirectory}/.ssh/cdenneen_ed25519_2024.pem";
      mode = "0400";
    };
    "codecommit_rsa" = {
      path = "${homeDirectory}/.ssh/codecommit_rsa";
      mode = "0400";
    };
    "id_rsa_cloud9" = {
      path = "${homeDirectory}/.ssh/id_rsa_cloud9";
      mode = "0400";
    };
    "aws-config" = {
      path = "${homeDirectory}/.aws/config";
      mode = "0440";
    };
    "gpg_gmail" = {
      path = "${homeDirectory}/.gnupg/private-keys-v1.d/personal.key";
      mode = "0400";
    };
    "gpg_ap" = {
      path = "${homeDirectory}/.gnupg/private-keys-v1.d/work.key";
      mode = "0400";
    };
  };
}
