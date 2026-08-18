#!/bin/bash

# .xinitrc — only used when starting dwm via startx (not SDDM)
# All setup is handled by scripts/autostart.sh

export QT_QPA_PLATFORMTHEME=qt6ct

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
exec dwm
