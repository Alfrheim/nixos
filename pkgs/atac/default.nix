# https://ryantm.github.io/nixpkgs/languages-frameworks/rust/
# https://github.com/oxalica/rust-overlay
{
  lib,
  fetchFromGitHub,
  rustPlatform,
  ...
}:
with import <nixpkgs>
{
  overlays = [
    (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
  ];
}; let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.stable."1.74.0".default;
    rustc = rust-bin.stable."1.74.0".default;
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "atac";
    version = "0.14.0";
    src = fetchFromGitHub {
      owner = "Julien-cpsn";
      repo = "ATAC";
      rev = "4e5a2d618948bb85ba65770b96ac87cfcfb03ded";
      sha256 = "sha256-d5qUleQrwWWTIEDj3VvJKpINHpc0rko18if4pv5GonU=";
    };

    cargoSha256 = "sha256-vlrllbcf5Y9DFwdekAHE5xtGlloKxTExXkp1LySEUK0=";

    meta = with lib; {
      description = "ATAC is Arguably a Terminal API Client. It is based on well-known clients such as Postman, Insomnia, or even Bruno, but inside your terminal without any specific graphical environment needed.";
      homepage = "https://github.com/Julien-cpsn/ATAC";
      license = licenses.mit;
      mainProgram = "atac";
    };
  }
