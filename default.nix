{ stdenv, fetchurl, lib, electron }:

stdenv.mkDerivation rec {
  pname = "aniparser";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/Sinedka/aniparser/releases/download/v0.3.1/dist-electron.tar.gz";
    sha256 = "0fdkn20bga3gchbwx89wzk6vrwrajp3m2k4jzsjh67zhd2xyws8r";
  };

  nativeBuildInputs = [ electron ];

  installPhase = ''
    mkdir -p $out/lib/$pname
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/512x512/apps

    # Распаковываем архив
    tar -xzf $src -C $out/lib/$pname

    # Проверяем наличие иконки и копируем её
    if [ -f $out/lib/$pname/dist-удусекщт/icon.png ]; then
      cp $out/lib/$pname/dist-react/icon.png $out/share/icons/hicolor/512x512/apps/$pname.png
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
exec ${electron}/bin/electron $out/lib/$pname/dist-electron/main.js "\$@"
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
