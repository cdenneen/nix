{pkgs, ...}: {
  programs.ssh = {
    enable = true;
    package = null; # Don't install ssh
    serverAliveInterval = 60;
    matchBlocks = {
      "i-* mi-*" = {
        proxyCommand = "${pkgs.dash}/bin/dash -c \"${pkgs.awscli2}/bin/aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'\"";
      };
      "c9" = {
        user = "ubuntu";
        hostname = "i-085b4f08b56c8b914";
        proxyCommand = "${pkgs.dash}/bin/dash -c \"AWS_PROFILE=sso-apss ${pkgs.awscli2}/bin/aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'\"";
        identityFile = "~/.ssh/id_rsa_cloud9";
      };
      "eros" = {
        user = "cdenneen";
        hostname = "10.224.11.147";
        identityFile = "~/.ssh/id_ed25519";
      };
      "eros-ssm" = {
        user = "cdenneen";
        hostname = "i-0a3e1df60bde023ad";
        proxyCommand = "${pkgs.dash}/bin/dash -c \"AWS_PROFILE=sso-apss ${pkgs.awscli2}/bin/aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'\"";
        identityFile = "~/.ssh/cdenneen_ed25519_2024.pem";
        identitiesOnly = true;
      };
      "git-codecommit.*.amazonaws.com" = {
        user = "APKA4GUE2SGMGTPZB44D";
        identityFile = "~/.ssh/codecommit_rsa";
      };
      "puppet" = {
        user = "root";
        hostname = "ctcpmaster01.ap.org";
        identityFile = "~/.ssh/id_rsa.fortress";
      };
    };
    extraConfig = ''
      # Use SSHFP
      VerifyHostKeyDNS ask
    '';
  };
  home.packages = with pkgs; [
    ssm-session-manager-plugin
  ];
}
