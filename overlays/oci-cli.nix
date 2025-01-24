let
  version = "3.51.4";
in
self: super: {
  oci-cli = super.oci-cli.overrideAttrs (old: {
    version = version;
    format = "setuptools";
    src = super.fetchFromGitHub {
      owner = "oracle";
      repo = "oci-cli";
      rev = "v${version}";
      hash = "sha256-yooEZuSIw2EMJVyT/Z/x4hJi8a1F674CtsMMGkMAYLg=";
    };
  });
}
