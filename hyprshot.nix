{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "hyprshot";

  src = pkgs.fetchFromGitHub {
    owner = "Gustash";
    repo = "hyprshot";
    rev = "main"; # Specify the commit hash or branch name
    sha256 = "nix-prefetch-git https://github.com/Gustash/hyprshot
"; # Fill with the actual sha256 hash
  };

  buildPhase = ''
    # Add build instructions if required, e.g., make
    echo "Building hyprshot"
  '';

  installPhase = ''
    mkdir -p $out/bin
    ln -s $src/hyprshot $out/bin/hyprshot
    chmod +x $src/hyprshot
  '';

  meta = {
    description = "A brief description of hyprshot";
    homepage = "https://github.com/Gustash/hyprshot.git";
    license = pkgs.lib.licenses.mit;
  };
}

