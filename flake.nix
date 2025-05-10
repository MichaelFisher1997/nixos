{
  description = "NixOS configuration for hypr-nix with zen-browser";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, zen-browser, ... }: {
    nixosConfigurations.hypr-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/hypr-nix/configuration.nix

      ];

      specialArgs = {
        zen-browser = zen-browser;
      };
    };
  };
}

