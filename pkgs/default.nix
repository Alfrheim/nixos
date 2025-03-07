# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib;
in rec {
  atac = pkgs.callPackage ./atac {};
  scls = pkgs.callPackage ./scls {};
  logss = pkgs.callPackage ./logss {};
  rainfrog = pkgs.callPackage ./rainfrog {};
  clojure-lsp = pkgs.callPackage ./clojure-lsp {};
  # kftray = pkgs.callPackage ./kftray {};
}
