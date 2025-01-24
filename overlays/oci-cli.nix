self: super: {
  oci-cli = super.oci-cli.overrideAttrs (old: {
    version = "3.51.4";
    src = super.fetchFromGitHub {
      hash = "sha256-lqqSx4jxQVq2pjVv9lvaX6nNK6OqtMjPqOtLMLpVMUU=";
    };
  });
}
