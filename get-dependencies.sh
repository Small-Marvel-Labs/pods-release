#!/bin/sh

set -eu

pacman -Syu --noconfirm \
	blueprint-compiler \
	desktop-file-utils \
	gtk4 \
	gtksourceview5 \
	libadwaita \
	meson \
	rust \
	vte4

get-debloated-pkgs --add-common --prefer-nano
