{ stdenv, fetchurl, lib, electron }:

stdenv.mkDerivation rec {
  pname = "aniparser";
  version = "0.3.2";

  src = fetchurl {
    url = "https://github.com/Sinedka/aniparser/releases/download/v0.3.2/dist-full.tar.gz";
    sha256 = "sha256-PehG5A5KtzfgYop+PnU0+dpxFTWHB7uorTZAjDSK0PU=";
  };

  nativeBuildInputs = [ electron ];

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/512x512/apps

    # Распаковываем архив
    tar -xzf $src -C $out/lib/
    mv $out/lib/dist-full $out/lib/$pname

    # Проверяем наличие иконки и копируем её
    if [ -f $out/lib/$pname/icon.png ]; then
      cp $out/lib/$pname/dist-full/icon.png $out/share/icons/hicolor/512x512/apps/$pname.png
    fi

    # Создаём desktop entry
    cat > $out/share/applications/$pname.desktop <<EOF
[Desktop Entry]
Name=AniParser
Comment=AniParser Electron application
Exec=$pname
Icon=$pname
Terminal=false
Type=Application
Categories=Utility;
EOF

    # Скрипт запуска
    cat > $out/bin/$pname <<EOF
#!/bin/sh
exec ${electron}/bin/electron $out/lib/$pname
EOF
    chmod +x $out/bin/$pname
  '';

  meta = with lib; {
    description = "AniParser Electron application";
    homepage = "https://github.com/Sinedka/aniparser";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux;
  };
}
