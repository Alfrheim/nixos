# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib;
in rec {
  atac = pkgs.callPackage ./atac {};
  scls = pkgs.callPackage ./scls {};
  logss = pkgs.callPackage ./logss {};
  # kftray = pkgs.callPackage ./kftray {};
}
