# Presentations

This repository contains a collection of presentations and the tools necessary to generate them. Specifically, the presentations are built using [Pandoc](https://pandoc.org)'s [reveal.js](https://revealjs.com/) support and packaged together as a [Nix flake](https://nixos.wiki/wiki/Flakes) for reproducibility.

With nix installed, run `nix build .#example` and then load the file created under `result/` (e.g. `result/example_presentation.html`) in your web browser.

## Example

This presentation demonstrates the general build process, theme support, and other principles without needing to be a fully-polished presentation.

