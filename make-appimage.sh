#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=${TAG#v}
export ARCH VERSION
export OUTPATH=./dist
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/com.github.marhkb.Pods.svg
export DESKTOP=/usr/share/applications/com.github.marhkb.Pods.desktop
export STARTUPWMCLASS=com.github.marhkb.Pods
export GTK_CLASS_FIX=1
export USE_HOST_DRIVERS_EXPERIMENTAL=1

meson setup --prefix=/usr --buildtype=release src/build src
meson install -C src/build

quick-sharun /usr/bin/pods

case "$ARCH" in
x86_64) updater_sha256=6bdaad9a3bcb0dd0cee345b89b24efb94c09c05e5c30ca88dadc1556344c5b18 ;;
aarch64) updater_sha256=b26a110337002cb19afc84824912821548e3c621228321a81e968cce7682b5d0 ;;
esac
wget -q -O AppDir/bin/appimageupdatetool "https://github.com/pkgforge-dev/AppImageUpdate/releases/download/0.4.1/appimageupdate-$ARCH-linux"
echo "$updater_sha256  AppDir/bin/appimageupdatetool" | sha256sum -c
chmod +x AppDir/bin/appimageupdatetool
cp self-updater.hook AppDir/bin/10-self-updater.hook

# quick-sharun only copies the hicolor icons, and Pods sets this theme at startup.
cp -r /usr/share/icons/com.github.marhkb.Pods AppDir/share/icons/

quick-sharun --make-appimage

# The test runs the app, and the updater would replace this build with the published release.
DISABLE_AUTO_UPDATES=1 quick-sharun --test ./dist/*.AppImage
