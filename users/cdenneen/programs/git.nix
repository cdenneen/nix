{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Chris Denneen";
    userEmail = "cdenneen@gmail.com";
    signing = {
      signByDefault = true;
      key = null;
    };
    ignores = [ ".DS_Store" "Thumbs.db" ];
    aliases = {
      cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "cdenneen";
      pull.rebase = "true";
      push.default = "tracking";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
    includes = [
      {
        condition = "gitdir:~/src/ap";
        contents = {
          user = {
            name = "Christopher Denneen";
            email = "CDenneen@ap.org";
            signingkey = "3834814930B83A30";
          };
          commit.gpgsign = true;
        };
      }
      {
        condition = "gitdir:~/src/personal";
        contents = {
          user = {
            name = "Chris Denneen";
            email = "cdenneen@gmail.com";
            signingkey = "BFEB75D960DFAA6B";
          };
          commit.gpgsign = true;
        };
      }
    ];
  };
}
