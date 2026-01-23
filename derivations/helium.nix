{pkgs ? import <nixpkgs> {}}: let
  heliumIcon = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium/blob/main/resources/branding/app_icon/raw.png?raw=true";
    sha256 = "0sr0m3xwff8f684j946kp17b3z4bh7y119ax1g6mcjclzcgwwcrs";
  };
in
  pkgs.appimageTools.wrapType2 {
    pname = "helium";
    version = "0.8.3.1";

    src = pkgs.fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/0.8.3.1/helium-0.8.3.1-x86_64.AppImage";
      sha256 = "18xlws93x03cb0xiylfyahx31w7yb9rwyihric4n9b7s9xknss8q";
    };

    extraInstallCommands = ''
        mkdir -p $out/share/applications
        mkdir -p $out/share/icons/hicolor/256x256/apps

        cat > $out/share/applications/helium.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=Helium
      Exec=helium
      Icon=helium
      Categories=Utility;
      EOF

        cp ${heliumIcon} \
           $out/share/icons/hicolor/256x256/apps/helium.png
    '';
  }
