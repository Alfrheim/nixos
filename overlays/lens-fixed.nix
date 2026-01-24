final: prev: {
  lens = prev.appimageTools.wrapType2 {
    pname = "lens";
    version = "2026.1.161237";

    src = prev.fetchurl {
      url = "https://api.k8slens.dev/binaries/Lens-2026.1.161237-latest.x86_64.AppImage";
      sha256 = "12wqibs652v9pdahn9nm0g1i296fy4qxn4cv186c6qa557k6jmcm";
    };

    nativeBuildInputs = [prev.makeWrapper];
    extraInstallCommands = ''
      wrapProgram $out/bin/lens \
        --set LENS_DISABLE_UPDATES 1 \
        --set ELECTRON_OZONE_PLATFORM_HINT x11 \
        --set OZONE_PLATFORM x11 \
        --unset WAYLAND_DISPLAY \
        --add-flags "--ozone-platform=x11 --disable-features=WaylandWindowDecorations"
    '';
  };
}
