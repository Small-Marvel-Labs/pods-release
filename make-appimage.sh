#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=${TAG#v}
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/com.github.marhkb.Pods.svg
export DESKTOP=/usr/share/applications/com.github.marhkb.Pods.desktop
export STARTUPWMCLASS=com.github.marhkb.Pods
export GTK_CLASS_FIX=1
export USE_HOST_DRIVERS_EXPERIMENTAL=1

tarball="pods-$TAG.tar.xz"
wget -q "https://github.com/marhkb/pods/releases/download/$TAG/$tarball" \
	"https://github.com/marhkb/pods/releases/download/$TAG/$tarball.sha256sum"
sha256sum -c "$tarball.sha256sum"
mkdir src
tar -xf "$tarball" -C src

meson setup --prefix=/usr --buildtype=release src/build src
meson install -C src/build

quick-sharun /usr/bin/pods

quick-sharun --make-appimage

quick-sharun --test ./dist/*.AppImage
