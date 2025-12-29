{
  pkgs,
  lib,
  stdenv,
  dpkg,
  fetchurl,
}: let
  roamApp =
    stdenv.mkDerivation {
      pname = "roam-unpacked";
      version = "latest";

      src = fetchurl {
        url = "https://download.ro.am/Roam/8a86d88cfc9da3551063102e9a4e2a83/latest/linux/x64/Roam.deb";
        sha256 = "sha256-koI+saAncSYRaAObUB1o9gmbTMY+YyFZMZz0domiI+s=";
      };

      nativeBuildInputs = [dpkg];

      unpackPhase = "
      mkdir -p $out
      dpkg-deb --fsys-tarfile $src | tar --no-same-owner -x -C $out
    ";

      installPhase = "
      mkdir -p $out/opt/roam
      cp -r $out/usr/* $out/opt/roam/
  ";
    };
in
  pkgs.writeShellApplication {
    name = "roam";

    runtimeInputs = [
      pkgs.steam-run
      pkgs.nspr
      pkgs.nss
    ];

    text = ''
      export LD_LIBRARY_PATH=${pkgs.nspr}/lib:${pkgs.nss}/lib:$LD_LIBRARY_PATH

      exec steam-run ${roamApp}/opt/roam/bin/roam \
        --ozone-platform=wayland \
        --enable-features=WebRTCPipeWireCapturer
    '';

    meta = with lib; {
      description = "Virtual office platform";
      homepage = "https://ro.am";
      license = licenses.mit;
      mainProgram = "roam";
    };
  }
