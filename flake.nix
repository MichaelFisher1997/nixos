{
  description = "NixOS configuration for hypr-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, zen-browser, ... }:
  let
    vars = import ./hosts/hypr-nix/vars.nix;
  in {
    nixosConfigurations.hypr-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/hypr-nix/default.nix
      ];

      specialArgs = {
        inherit vars;
        inherit zen-browser;
        unstable = nixpkgs-unstable;
      };
    };
  };
}