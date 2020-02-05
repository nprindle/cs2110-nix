{ stdenv, lib, makeWrapper, makeDesktopItem
, openjdk11
, gtk3
, createDesktop ? true
}:

let
  pname = "CircuitSim";
  version = "1.8.2";
  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    desktopName = pname;
    genericName = pname;
  };
  schemaPath = "${gtk3}/share/gsettings-schemas/gtk+3-${gtk3.version}";
in stdenv.mkDerivation (rec {
  inherit pname version;

  buildInputs = [ makeWrapper ];

  unpackPhase = "true";
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out/bin"
    makeWrapper \
      "${openjdk11}/bin/java" \
      "$out/bin/${pname}" \
      --prefix XDG_DATA_DIRS : "${schemaPath}" \
      --add-flags "-jar ${./CircuitSim1.8.2.jar}"
  '' + lib.optionalString createDesktop ''
    mkdir -p "$out/share/applications"
    cp ${desktopItem}/share/applications/* "$out/share/applications"
  '';
} // lib.optionalAttrs createDesktop { inherit desktopItem; })
