#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# If we are on TTY1 and not already in a graphical session, start DWM
if [ -z "$DISPLAY" ] \
  && [ "${XDG_VTNR:-}" = "1" ] \
  && [ -z "${LIGHTDM_SESSION_ID:-}" ] \
  && ! systemctl is-active --quiet lightdm 2>/dev/null; then
  exec startx
fi