{
  description = "Build presentations using Pandoc and reveal.js";

  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
    in rec {
      packages.examplePresentation = pkgs.stdenvNoCC.mkDerivation rec {
        name = "example_presentation";
        src = ./example;
        buildInputs = [ pkgs.pandoc ];
        phases = ["unpackPhase" "buildPhase" "installPhase"];
        buildPhase = ''
          pandoc \
            --standalone \
            --slide-level=2 \
            --to=revealjs \
            --out=example_presentation.html \
            example_presentation.md
        '';
        installPhase = ''
          mkdir -p $out
          cp example_presentation.html $out/
        '';
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixpkgs-fmt
        ];
      };
    });
}
