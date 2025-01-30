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
      owner = "todoesverso";
      repo = "logss";
      rev = "9005905752ce6ac37b8d97a261446afe4c44a683";
      sha256 = "sha256-b4yxePBe2SmMHXeI7PaipaixNlEPdZT480eSR+7RO04=";
    };

    cargoHash = "sha256-uKntqF/a6VxbRoge7uck4+jqGO5XZq9O0X4i8EaeFUo=";
    doCheck = false;

    meta = with lib; {
      description = "A simple completion language server";
      homepage = "https://github.com/estin/simple-completion-language-server";
      license = licenses.mit;
      mainProgram = "simple-completion-language-server";
    };
  }
