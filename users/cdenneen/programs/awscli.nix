{
  pkgs,
  ...
}:
{
  programs.awscli = {
    enable = true;
    package = pkgs.awscli2;
    credentials = {
      "nextology" = {
        credential_process = "sh -c \"op --account=ap --vault=GSS item get --format=json --fields=label=AccessKeyId,label=SecretAccessKey nextology | jq 'map({key: .label, value: .value}) | from_entries + {Version: 1}'\"";
      };
    };
  };
}
