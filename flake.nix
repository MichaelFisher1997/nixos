{
  description = "NixOS configuration for hypr-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, zen-browser, ... }:
  let
    mkHost = hostName: vars: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/${hostName}/default.nix
      ];

      specialArgs = {
        inherit vars zen-browser;
        unstable = nixpkgs-unstable;
      };
    };
  in {
    nixosConfigurations = {
      hypr-nix = mkHost "hypr-nix" (import ./hosts/hypr-nix/vars.nix);
      hyprtop = mkHost "hyprtop" (import ./hosts/hyprtop/vars.nix);
    };
  };
}
