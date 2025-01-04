{
  inputs = {
    # This points to the same nixpkgs that nixos-cosmic is using by default.
    # If you want to stick to a stable channel, you can switch "nixpkgs" to "nixpkgs-stable".
    nixpkgs.follows = "nixos-cosmic/nixpkgs";

    # The main input: NixOS COSMIC
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  outputs = { self, nixpkgs, nixos-cosmic }:
    {
      nixosConfigurations = {
        # Replace "my-hostname" with your actual hostname
        hypr-nix = nixpkgs.lib.nixosSystem {
          # Point to an existing configuration file or create a new one
          modules = [
            # Set up the COSMIC binary cache (substituter)
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [
                  "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
                ];
              };
            }

            # Import the default COSMIC NixOS module
            nixos-cosmic.nixosModules.default

            # Your existing configuration – typically you’d have:
            ./configuration.nix

            # Optionally, you could enable COSMIC right here:
            {
              services.desktopManager.cosmic.enable = true;
              services.displayManager.cosmic-greeter.enable = true;
            }
          ];
        };
      };
    };
}

