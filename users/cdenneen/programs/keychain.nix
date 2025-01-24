{
  programs.keychain = {
    enable = true;
    agents = [ "gpg" ];
    keys = [
      "0x3834814930B83A30"
      "0xBFEB75D960DFAA6B"
    ];
    extraFlags = [
      "--dir $XDG_RUNTIME_DIR"
      "--absolute"
      "--quiet"
    ];
  };
}
