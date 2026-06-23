#!/usr/bin/env bash

set -xe

HERE=$(dirname $(realpath -s $0))

# GTK Theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
mkdir -p $HOME/.config/gtk-3.0/
ln -sf $HERE/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/
mkdir -p $HOME/.config/gtk-4.0/
ln -sf $HERE/gtk-4.0/settings.ini $HOME/.config/gtk-4.0/

# Cursor
mkdir -p $HOME/.icons/default
ln -sf $HERE/.icons/default/index.theme $HOME/.icons/default/

# KDE theme
ln -sf $HERE/kdeglobals $HOME/.config/

# Darkly settings
ln -sf $HERE/darklyrc $HOME/.config/

# Fonts
mkdir -p $HOME/.config/fontconfig
ln -sf $HERE./fontconfig/fonts.conf $HOME/.config/fontconfig/

mkdir -p $HOME/.config/environment.d
ln -sf $HERE/environment.d/theme.conf $HOME/.config/environment.d/
