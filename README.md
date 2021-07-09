# Cutefish Video Player

An open source video player built with Qt/QML and libmpv.

Based on [haruna](https://github.com/g-fb/haruna)

# Features

these are just some features that set Haruna apart from others players

- play online videos, through youtube-dl

- toggle playlist with mouse-over, playlist overlays the video

- auto skip chapter containing certain words

- configurable shortcuts and mouse buttons

- quick jump to next chapter by middle click on progress bar

# Dependencies

### Build time
- Qt5Core
- Qt5DBus
- Qt5Qml
- Qt5Quick
- Qt5QuickControls2
- Libmpv
- ExtraCmakeModules
- KF5Config
- KF5CoreAddons
- KF5FileMetaData
- KF5I18n
- KF5IconThemes
- KF5KIO
- KF5Kirigami2
- KF5XmlGui

### Runtime
- Kio-extras
- Breeze icons
- Breeze widgets style
- QQC2-Desktop-Style
- Youtube-dl

# Build and Install

```
mkdir build
cd build
cmake ..
make
sudo make install
```

# License

This project has been licensed by GPLv3.