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
    cargo = rust-bin.stable."1.81.0".default;
    rustc = rust-bin.stable."1.81.0".default;
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "Logss";
    version = "0.0.3";
    src = fetchFromGitHub {
      owner = "achristmascarl";
      repo = "rainfrog";
      rev = "eac01a4c4581ab6104e1f94f8b442a96ed1fb3be";
      sha256 = "sha256-5DMAfv1rpsA6LkNP3xqAERi2oXUwySIJJ7lTQGNQASM=";
    };

    cargoHash = "sha256-ISJ32cgCKzC4EtbEAAnl3EXaz9qXG5HfqEuVHBFM2Gk=";
    doCheck = false;

    meta = with lib; {
      description = "A simple completion language server";
      homepage = "https://github.com/achristmascarl/rainfrog/";
      license = licenses.mit;
      mainProgram = "rainfrog";
    };
  }
