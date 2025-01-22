{ config, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;
in 
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    loginExtra = builtins.readFile ./zlogin;
    logoutExtra = builtins.readFile ./zlogout;

    history = {
      append = true;
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = ".local/state/zsh/history";
      save = 100000;
      share = true;
      size = 130000;
    };

    localVariables = {
    };

    shellAliases = {
      c = "clear";
      ll = "ls -lahF --color=always";
      e = "$EDITOR";
      se = "sudoedit";
      ec = "nvim --cmd ':lua vim.g.noplugins=1' "; #nvim --clean
      g = "git";

      ga = "git add";
      gb = "git branch";
      gc = "git commit";
      gcm = "git commit -m";
      gco = "git checkout";
      gcob = "git checkout -b";
      gcp = "git cherry-pick";
      gd = "git diff";
      gdiff = "git diff";
      gf = "git fetch";
      gl = "git prettylog";
      gm = "git merge";
      gp = "git push";
      gpr = "git pull --rebase";
      gr = "git rebase -i";
      gs = "git status -sb";
      gt = "git tag";
      gu = "git reset @ --"; # think git unstage
      gx = "git reset --hard @";

      jf = "jj git fetch";
      jn = "jj new";
      js = "jj st";

      k = "kubectl";
      kprod = "switch eks_eks-prod-us-east-1-prod-2-use1/eks_prod-2-use1";
      kshared = "switch eks_eks-apss-us-east-1-shared-1-use1/eks_shared-1-use1";
      kinteract = "switch eks_eks-prod-us-east-1-apinteractives-datateam/eks_apinteractives-datateam";
      kinteractdr = "switch eks_eks-prod-us-west-2-apinteractives-datateam-dr/eks_apinteractives-datateam-dr";

      vi = "nvim";
      vim = "nvim";
      ls = "ls --color";
      sso = "aws sso login --profile sso-apss --no-browser";
      s = if isDarwin then "darwin-rebuild switch --flake github:cdenneen/nixos-config#mac" else "sudo nixos-rebuild switch --flake github:cdenneen/nixos-config#vm-aarch64-utm";

    } // (if isLinux then {
      # Two decades of using a Mac has made this such a strong memory
      # that I'm just going to keep it consistent.
      pbcopy = "xclip";
      pbpaste = "xclip -o";
    } else {});

    sessionVariables = {
      # This is required for the zoxide integration
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=8";
    } // (if isDarwin then {
      XDG_RUNTIME_DIR = "$(getconf DARWIN_USER_TEMP_DIR)";
    } else {});

    initExtra = ''
      bindkey -e

      bindkey '^[w' kill-region

      zle_highlight+=(paste:none)

      #█▓▒░ load configs
      for config (~/.config/zsh/*.zsh) source $config

      # Determine the target file of the symlink
      secrets_target=$(readlink ~/.secrets || echo ~/.secrets)

      # Check if the target exists and its modification time
      if [ ! -e "$secrets_target" ] || [ -n "$(find "$secrets_target" -mtime +7 2>/dev/null)" ]; then
        update_secrets
      fi

      source <(switcher init zsh)
      source <(switch completion zsh)

      source ~/.secrets
    '';

    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      # {
      #   name = "powerlevel10k";
      #   src = pkgs.zsh-powerlevel10k;
      #   file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      # }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
  };
}
