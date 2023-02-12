{
  description = "Build presentations using Pandoc and reveal.js";

  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        pandocPresentation = { presentationName, sourceFiles }: pkgs.stdenvNoCC.mkDerivation rec {
          name = presentationName;
          src = sourceFiles;
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
              --out=${presentationName}.html \
              ${presentationName}.md
          '';
          installPhase = ''
            mkdir -p $out
            cp example_presentation.html $out/
          '';
        };
      in
      rec {
        packages.examplePresentation = pandocPresentation {
          presentationName = "example_presentation";
          sourceFiles = ./example;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            pandoc
            nixpkgs-fmt
          ];
        };
      });
}
