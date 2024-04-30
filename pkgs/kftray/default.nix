# https://ryantm.github.io/nixpkgs/languages-frameworks/rust/
# https://github.com/oxalica/rust-overlay
{lib, ...}:
with import <nixpkgs> {}; let
  pname = "kftray";
  version = "0.9.7";

  src = fetchurl {
    url = "https://github.com/hcavarsan/kftray/releases/download/v${version}/kftray_${version}_amd64.AppImage";
    # hash = "sha256-mU7FDO2Ut1aA93lRBoSZQs6GQJ18pPunHugfrC27eAg=";
    hash = "sha256-w6mvAHANzdirnB5ypvY5FsKCe1+ZJjrQy5+bkyhHy9k=";
  };

  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapAppImage {
    inherit pname version;
    src = appimageContents;

    extraPkgs = {pkgs, ...} @ args: [
      pkgs.libthai
      pkgs.hidapi
      pkgs.python3
      pkgs.python311Packages.py-multibase
      # (pkgs.python3.withPackages (python-pkgs: [
      # python
      # ]))
      webkitgtk
      webkitgtk_4_1
      gtk3
      cairo
      gdk-pixbuf
      glib
      dbus
      openssl_3
      librsvg
      libayatana-appindicator
    ];
    # ++ appimageTools.defaultFhsEnvArgs.multiPkgs args;

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
