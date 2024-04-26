# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
# {pkgs ? import <nixpkgs> {}}: pkgs: {
{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib;
in rec {
  # example = pkgs.callPackage ./example { };
  atac = pkgs.callPackage ./atac {};
}
