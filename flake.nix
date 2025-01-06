{
  description = "Chris Denneen system config";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Build a custom WSL installer
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

  };

  outputs = { self, nixpkgs, home-manager, sops-nix, darwin, ghostty, ... }@inputs: let
    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = [

    ];
    
    mkSystem = import ./lib/mksystem.nix {
      inherit self overlays nixpkgs inputs;
    };
  in {

    nixosConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" rec {
      system = "aarch64-linux";
      user = "cdenneen";
    };

    darwinConfigurations.macbook = mkSystem "macbook-pro-m1" rec {
      system = "aarch64-darwin";
      user = "cdenneen";
      darwin = true;
    };

    darwinConfigurations.macbook_x86 = mkSystem "macbook-pro-m1" rec {
      system = "x86_64-darwin";
      user = "cdenneen";
      darwin = true;
    };
  };
}
