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
    pname = "simple-completion-language-server";
    version = "0.1.0";
    src = fetchFromGitHub {
      owner = "estin";
      repo = "simple-completion-language-server";
      rev = "main";
      sha256 = "sha256-jb4VEHJCCqYVS4llXJoyZpAy9OdwVD8isChhYe0Jr4I=";
    };

    cargoHash = "sha256-Ki0w+1nGIXGpMNko5aZ0BegWtsBwjo2ef4bDXw/vz0g=";
    doCheck = false;

    meta = with lib; {
      description = "A simple completion language server";
      homepage = "https://github.com/estin/simple-completion-language-server";
      license = licenses.mit;
      mainProgram = "simple-completion-language-server";
    };
  }
