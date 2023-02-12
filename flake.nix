{
  description = "Build presentations using Pandoc and reveal.js";

  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        pandocPresentation = { name, src }: pkgs.stdenvNoCC.mkDerivation {
          name = name;
          src = src;
          buildInputs = [ pkgs.pandoc ];
          phases = [ "unpackPhase" "buildPhase" "installPhase" ];
          buildPhase = ''
            pandoc \
              --standalone \
              --embed-resources \
              --slide-level=2 \
              --variable=theme:white \
              --css=${./theme/slides-style.css} \
              --highlight-style ${./theme/code-style.theme} \
              --to=revealjs \
              --out=${name}.html \
              ${name}.md
          '';
          installPhase = ''
            mkdir -p $out
            cp ${name}.html $out/
          '';
        };
      in
      rec {
        packages.example = pandocPresentation {
          name = "example_presentation";
          src = ./example;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            pandoc
            nixpkgs-fmt
          ];
        };
      });
}
