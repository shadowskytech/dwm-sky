# DWM-Sky Architecture

## Repository

DWM source/project:

`~/git-repos/dwm-sky`

Dotfiles:

`~/dotfiles/dwm`

GNU Stow target:

`$HOME`

## Runtime

Active DWM binary:

`/usr/local/bin/dwm`

DWM runtime data:

`~/.local/share/dwm-sky`

User configuration:

`~/.config/dwm-sky`

## Theme

Canonical theme database:

`~/.config/dwm-sky/themes.toml`

Global theme components:

- DWM
- Polybar
- Rofi
- terminals (Alacritty, Kitty, Ghostty)
- GTK
- Qt

Mouse cursor is independent from global theme switching.

## Appearance

GTK:

- GTK2: `~/.gtkrc-2.0`
- GTK3: `~/.config/gtk-3.0/settings.ini`
- GTK4: `~/.config/gtk-4.0/settings.ini`
- GSettings color-scheme and gtk-theme when available

Qt:

- Qt6 uses qt6ct (`QT_QPA_PLATFORMTHEME=qt6ct`)
- Qt5 is handled separately when required

xsettingsd:

Installed but intentionally inactive.

## Generated Files

Generated theme outputs (e.g. `active-theme.toml`, `active-theme.conf`, `colors.ini`, `theme-env.sh`) are runtime state and are not Stow-managed.

## Legacy

The Titus configuration is retained for reference/rollback but is not the active DWM-Sky configuration.
