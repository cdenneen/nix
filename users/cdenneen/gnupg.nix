{ config, pkgs, ... }:{
  home.packages = with pkgs; [
    pass
    gnupg
    pinentry-curses
    keychain
  ];
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      defaultCacheTtl = 31536000;
      maxCacheTtl = 31536000;
      
      extraConfig = ''
        pinentry-program ${pkgs.pinentry-curses}/bin/pinentry
      '';
    };
  };
  programs = {
    keychain = {
      enable = true;
      agents = [
        "ssh"
        "gpg"
      ];
      keys = [
        "~/.ssh/id_ed25519"
        "0x3834814930B83A30"
        "0xBFEB75D960DFAA6B"
      ];
      extraFlags = [
        "--dir $XDG_RUNTIME_DIR"
        "--absolute"
        "--quiet"
      ];
    };
    gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.gnupg";
      settings = {
        #█▓▒░ interface
        no-greeting = true;
        use-agent = true;
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        keyid-format = "0xlong";
        keyserver = "hkp://keys.gnupg.net";
        fixed-list-mode = true;
        charset = "utf-8";
        with-fingerprint = true;
        require-cross-certification = true;
        no-emit-version = true;
        no-comments = true;
        
        #█▓▒░ algos
        personal-digest-preferences = "SHA512 SHA384 SHA224";
        default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";
        personal-cipher-preferences = "AES256 AES192 AES CAST5";
        s2k-cipher-algo = "AES256";
        s2k-digest-algo = "SHA512";
        cert-digest-algo = "SHA512";
      };
    };
  };
}
