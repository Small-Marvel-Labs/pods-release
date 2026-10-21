#!/bin/sh

set -eu

pacman -Syu --noconfirm \
	blueprint-compiler \
	desktop-file-utils \
	gtk4 \
	gtksourceview5 \
	libadwaita \
	mesa \
	meson \
	rust \
	vte4
