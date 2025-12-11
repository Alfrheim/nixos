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
      sha256 = "sha256-Vuy3uv8Uy4p/ajHBGED0r8k3sNb8B2BgFSnrvwU7uXs=";
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
        mesa.drivers
        libglvnd
        wayland
        xorg.libxshmfence
        libsecret
        gcc-unwrapped.lib
        xdg-desktop-portal
        xdg-desktop-portal-hyprland
        pipewire
        libdrm
      ];

    # runScript = "${roamApp}/opt/roam/bin/roam --enable-features=WebRTCPipeWireCapturer";
    runScript = "
       # Set the library path to include OpenGL drivers
      export LIBVA_DRIVER_NAME=iHD
      export MESA_LOADER_DRIVER_OVERRIDE=iris
      export LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver/lib32:$LD_LIBRARY_PATH
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=Hyprland
      export GTK_USE_PORTAL=1
      export WEBRTC_PIPEWIRE_NO_DMABUF=1
      export WAYLAND_DISPLAY=$WAYLAND_DISPLAY:-wayland-0
      # Do NOT override XDG_DESKTOP_PORTAL_DIR

      export LIBGL_DRIVERS_PATH=/run/opengl-driver/lib/dri
      export LD_LIBRARY_PATH=/run/opengl-driver/lib$LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH
      [ -d /run/opengl-driver-32/lib ] && export LD_LIBRARY_PATH=/run/opengl-driver-32/lib:$LD_LIBRARY_PATH


      exec ${roamApp}/opt/roam/bin/roam \
        --ozone-platform=wayland \
        --enable-features=WebRTCPipeWireCapturer,UseOzonePlatform \
        --use-gl=egl
        ";

    # runScript = "
    #   export XDG_SESSION_TYPE=wayland
    #   export XDG_CURRENT_DESKTOP=Hyprland
    #   export XDG_DESKTOP_PORTAL_DIR=/run/user/$(id -u)/flatpak-portals
    #   export WAYLAND_DISPLAY=$WAYLAND_DISPLAY:-wayland-0
    #    exec ${roamApp}/opt/roam/bin/roam \
    # --enable-features=WebRTCPipeWireCapturer \
    # --ozone-platform=wayland \
    # --enable-wayland-ime \
    # ";
  }
