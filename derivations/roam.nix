{
  stdenv,
  buildFHSUserEnv,
  dpkg,
  fetchurl,
  glib,
  gtk3,
  pango,
  cairo,
  atk,
  at-spi2-core,
  xorg,
  libxkbcommon,
  nspr,
  nss,
  dbus,
  cups,
  alsa-lib,
  libnotify,
  expat,
  systemd,
  libGL,
  mesa,
  libsecret,
  gcc-unwrapped,
}: let
  roamApp = stdenv.mkDerivation {
    name = "roam-unpacked";
    src = fetchurl {
      url = "https://download.ro.am/Roam/8a86d88cfc9da3551063102e9a4e2a83/latest/linux/x64/Roam.deb";
      sha256 = "sha256-HCGm5kyuDMWzTcYoqTynzZ3VU6DtDp4YNjvGVOanMVc=";
    };

    nativeBuildInputs = [dpkg];

    # unpackPhase = ''
    #   dpkg-deb -x $src $out
    # '';
    unpackPhase = ''
      mkdir -p $out
      dpkg-deb --fsys-tarfile $src | tar --no-same-owner -xvf - -C $out || true
    '';

    installPhase = ''
      mkdir -p $out/opt/roam
      cp -r $out/usr/* $out/opt/roam/

      # Install desktop entry
      mkdir -p $out/share/applications
      cp $out/opt/roam/share/applications/roam.desktop $out/share/applications/

      # Install icon if present
      if [ -d $out/opt/roam/share/icons ]; then
        cp -r $out/opt/roam/share/icons $out/share/
      fi
    '';

    # installPhase = ''
    #   mkdir -p $out/opt/roam
    #   cp -r $out/usr/* $out/opt/roam/
    # '';
  };
in
  buildFHSUserEnv {
    name = "roam";

    targetPkgs = pkgs:
      with pkgs; [
        glib
        gtk3
        pango
        cairo
        atk
        at-spi2-core
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libxcb
        xorg.xcbutil
        libxkbcommon
        nspr
        nss
        dbus
        cups
        alsa-lib
        libnotify
        expat
        systemd
        libGL
        mesa
        libsecret
        gcc-unwrapped.lib
        xdg-desktop-portal
        xdg-desktop-portal-wlr
      ];

    # runScript = "${roamApp}/opt/roam/bin/roam --enable-features=WebRTCPipeWireCapturer";
    runScript = "
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_DESKTOP_PORTAL_DIR=/run/user/$(id -u)/flatpak-portals
      export WAYLAND_DISPLAY=$WAYLAND_DISPLAY:-wayland-0
       exec ${roamApp}/opt/roam/bin/roam \
    --enable-features=WebRTCPipeWireCapturer \
    --ozone-platform=wayland \
    --enable-wayland-ime \
    --disable-features=UseOzonePlatform
    ";
  }
