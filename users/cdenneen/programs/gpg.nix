{
  config,
  ...
}:
{
  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.gnupg";
    publicKeys = [
      { source = ../keys/personal.pub; trust = 5; }
      { source = ../keys/work.pub; trust = 5; }
    ];
    settings = {
      use-agent = true;
    };
    scdaemonSettings = {
      disable-ccid = true; # disable gnupg's built-in smartcard reader functionality
    };
  };
}
