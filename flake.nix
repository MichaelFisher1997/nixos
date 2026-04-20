{
  description = "NixOS configuration for hypr-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, zen-browser, ... }:
  let
    mkHost = system: hostName: vars: nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./hosts/${hostName}/default.nix
      ];

      specialArgs = {
        inherit vars home-manager zen-browser;
        unstable = nixpkgs-unstable;
      };
    };
  in {
    nixosConfigurations = {
      hypr-nix = mkHost "x86_64-linux" "hypr-nix" (import ./hosts/hypr-nix/vars.nix);
      hyprtop = mkHost "x86_64-linux" "hyprtop" (import ./hosts/hyprtop/vars.nix);
      hyprpi = mkHost "aarch64-linux" "hyprpi" (import ./hosts/hyprpi/vars.nix);
    };
  };
}
