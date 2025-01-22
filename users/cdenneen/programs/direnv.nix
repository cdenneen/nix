{
  programs.direnv= {
    enable = true;

    config = {
      global = {
        load_dotenv = true;
      };
      whitelist = {
        prefix= [
          "~/src/ap/eks-live"
        ];

        exact = ["$HOME/.envrc"];
      };
    };
  };
}
