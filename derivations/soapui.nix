{
  fetchurl,
  lib,
  stdenv,
  writeText,
  zulu11,
  makeWrapper,
  nixosTests,
}: let
  jdk = zulu11;
in
  stdenv.mkDerivation rec {
    pname = "soapui";
    version = "5.7.2";

    src = fetchurl {
      url = "https://dl.eviware.com/soapuios/5.7.2/SoapUI-5.7.2-linux-bin.tar.gz";
      # url = "https://s3.amazonaws.com/downloads.eviware/soapuios/${version}/SoapUI-${version}-linux-bin.tar.gz";
      sha256 = "sha256-pT0ZANVC7Sv7zxMDPY86aclIUGZeazOZadiVVsmEjtw=";
    };

    nativeBuildInputs = [makeWrapper];
    buildInputs = [jdk];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/java
      cp -R bin lib $out/share/java

      makeWrapper $out/share/java/bin/soapui.sh $out/bin/soapui --set SOAPUI_HOME $out/share/java

      runHook postInstall
    '';

    patches = [
      # Adjust java path to point to derivation paths
      (writeText "soapui-${version}.patch" ''
        --- a/bin/soapui.sh
        +++ b/bin/soapui.sh
        @@ -50,7 +50,7 @@
         #JAVA 16
         JAVA_OPTS="$JAVA_OPTS --illegal-access=permit"

        -JFXRTPATH=`java -cp $SOAPUI_CLASSPATH com.eviware.soapui.tools.JfxrtLocator`
        +JFXRTPATH=`${jdk}/bin/java -cp $SOAPUI_CLASSPATH com.eviware.soapui.tools.JfxrtLocator`
         SOAPUI_CLASSPATH=$JFXRTPATH:$SOAPUI_CLASSPATH

         if $darwin
        @@ -85,4 +85,4 @@
         echo =
         echo ================================

        -java $JAVA_OPTS -cp $SOAPUI_CLASSPATH com.eviware.soapui.SoapUI "$@"
        +${jdk}/bin/java $JAVA_OPTS -cp $SOAPUI_CLASSPATH com.eviware.soapui.SoapUI "$@"
      '')
    ];

    passthru.tests = {inherit (nixosTests) soapui;};

    meta = with lib; {
      description = "The Most Advanced REST & SOAP Testing Tool in the World";
      homepage = "https://www.soapui.org/";
      sourceProvenance = with sourceTypes; [binaryBytecode];
      license = "SoapUI End User License Agreement";
      maintainers = with maintainers; [gerschtli];
      platforms = platforms.all;
      mainProgram = "soapui";
    };
  }
