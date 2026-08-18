#!/bin/bash

# .xinitrc — only used when starting dwm via startx (not SDDM)
# All setup is handled by scripts/autostart.sh

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
exec dwm
