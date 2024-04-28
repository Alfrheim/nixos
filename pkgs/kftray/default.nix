# https://ryantm.github.io/nixpkgs/languages-frameworks/rust/
# https://github.com/oxalica/rust-overlay
{lib, ...}:
with import <nixpkgs> {}; let
  pname = "kftray";
  version = "0.9.8";

  src = fetchurl {
    url = "https://github.com/hcavarsan/kftray/releases/download/v${version}/kftray_${version}_amd64.AppImage";
    hash = "sha256-mU7FDO2Ut1aA93lRBoSZQs6GQJ18pPunHugfrC27eAg=";
  };

  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapAppImage {
    inherit pname version;
    src = appimageContents;

    extraPkgs = {pkgs, ...} @ args:
      [
        pkgs.libthai
        pkgs.hidapi
      ]
      ++ appimageTools.defaultFhsEnvArgs.multiPkgs args;

    extraInstallCommands = ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}
      # Add desktop convencience stuff
      install -Dm444 ${appimageContents}/kftray.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/kftray.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/kftray.desktop \
        --replace 'Exec=AppRun' "Exec=$out/bin/${pname} --"
    '';

    meta = with lib; {
      description = "kftray is a cross-platform system tray app made with Tauri (Rust and TypeScript) for Kubernetes users. It simplifies setting up multiple kubectl port forward configurations through a user-friendly interface. Easily store and manage all configurations from local files or GitHub repositories.";
      homepage = "https://github.com/hcavarsan/kftray";
      license = licenses.mit;
      mainProgram = "kftray";
    };
  }
