#!/bin/bash
# Apply the optional GTK/Qt part of the active DWM-Sky theme.
#
# DWM/Polybar/Rofi/terminal behavior remains in theme-apply.sh.  This helper
# deliberately owns only GTK theme name and dark/light preference, plus an
# explicitly validated qt6ct color-scheme mapping when one is present.

set -euo pipefail

THEMES_FILE="$HOME/.config/dwm-sky/themes.toml"
if [[ ! -f "$THEMES_FILE" ]]; then
    echo "global-appearance-apply: themes.toml not found at $THEMES_FILE" >&2
    exit 1
fi

toml_get() {
    local section="$1" key="$2" file="$3"
    awk -v sec="[$section]" -v key="$key" '
        /^\[/ { in_sec = ($0 == sec) }
        in_sec && $0 ~ "^[[:space:]]*" key "[[:space:]]*=" {
            sub(/^[^=]*=[[:space:]]*/, "")
            gsub(/"/, "")
            gsub(/[[:space:]]+#.*$/, "")
            sub(/[[:space:]]+$/, "")
            print
            exit
        }
    ' "$file"
}

THEME_NAME="$(toml_get active theme "$THEMES_FILE")"
if [[ -z "$THEME_NAME" ]]; then
    echo "global-appearance-apply: no active theme in $THEMES_FILE" >&2
    exit 1
fi

SECTION="theme.$THEME_NAME"
theme_get() {
    toml_get "$SECTION" "$1" "$THEMES_FILE"
}

DARK_MODE="$(theme_get dark_mode)"
GTK_THEME="$(theme_get gtk_theme)"
QT_COLOR_SCHEME="$(theme_get qt_color_scheme)"

rewrite_ini_key() {
    local file="$1" key="$2" value="$3" tmp
    [[ -f "$file" ]] || return 1
    tmp=$(mktemp "${file}.phase2.XXXXXX")
    if ! awk -v key="$key" -v value="$value" '
        BEGIN { changed = 0 }
        $0 ~ "^[[:space:]]*" key "[[:space:]]*=" {
            print key "=" value
            changed = 1
            next
        }
        { print }
        END { if (!changed) exit 2 }
    ' "$file" > "$tmp"; then
        rm -f "$tmp"
        return 1
    fi
    # Redirecting into the existing path follows a Stow symlink and keeps it.
    cat "$tmp" > "$file"
    rm -f "$tmp"
}

rewrite_gtkrc_theme() {
    local file="$1" value="$2" tmp
    [[ -f "$file" ]] || return 1
    tmp=$(mktemp "${file}.phase2.XXXXXX")
    if ! awk -v value="$value" '
        BEGIN { changed = 0 }
        /^[[:space:]]*gtk-theme-name[[:space:]]*=/ {
            print "gtk-theme-name=\"" value "\""
            changed = 1
            next
        }
        { print }
        END { if (!changed) exit 2 }
    ' "$file" > "$tmp"; then
        rm -f "$tmp"
        return 1
    fi
    cat "$tmp" > "$file"
    rm -f "$tmp"
}

set_dark_preference() {
    local file="$1" value="$2"
    if rewrite_ini_key "$file" gtk-application-prefer-dark-theme "$value"; then
        printf 'GTK preference updated: %s\n' "$file"
    else
        printf 'GTK preference unavailable: %s\n' "$file" >&2
    fi
}

if [[ "$DARK_MODE" == "true" || "$DARK_MODE" == "false" ]]; then
    if [[ "$DARK_MODE" == "true" ]]; then
        GTK_DARK=1
        GTK_COLOR_SCHEME=prefer-dark
    else
        GTK_DARK=0
        GTK_COLOR_SCHEME=prefer-light
    fi

    for gtk_settings in \
        "$HOME/.config/gtk-3.0/settings.ini" \
        "$HOME/.config/gtk-4.0/settings.ini"; do
        set_dark_preference "$gtk_settings" "$GTK_DARK"
    done

    if command -v gsettings >/dev/null 2>&1; then
        if gsettings writable org.gnome.desktop.interface color-scheme >/dev/null 2>&1; then
            gsettings set org.gnome.desktop.interface color-scheme "$GTK_COLOR_SCHEME" \
                || printf 'GSettings color-scheme update failed\n' >&2
        fi
    fi
else
    printf 'GTK dark/light preference unavailable for theme: %s\n' "$THEME_NAME" >&2
fi

if [[ -n "$GTK_THEME" ]]; then
    GTK_THEME_DIR=""
    for candidate in "$HOME/.themes/$GTK_THEME" "/usr/share/themes/$GTK_THEME"; do
        if [[ -d "$candidate" ]]; then
            GTK_THEME_DIR="$candidate"
            break
        fi
    done

    if [[ -n "$GTK_THEME_DIR" ]]; then
        for gtk_settings in \
            "$HOME/.config/gtk-3.0/settings.ini" \
            "$HOME/.config/gtk-4.0/settings.ini"; do
            if rewrite_ini_key "$gtk_settings" gtk-theme-name "$GTK_THEME"; then
                printf 'GTK theme updated: %s\n' "$gtk_settings"
            else
                printf 'GTK theme key unavailable: %s\n' "$gtk_settings" >&2
            fi
        done
        if rewrite_gtkrc_theme "$HOME/.gtkrc-2.0" "$GTK_THEME"; then
            printf 'GTK2 theme updated\n'
        else
            printf 'GTK2 theme key unavailable\n' >&2
        fi

        if command -v gsettings >/dev/null 2>&1 && \
           gsettings writable org.gnome.desktop.interface gtk-theme >/dev/null 2>&1; then
            gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" \
                || printf 'GSettings GTK theme update failed\n' >&2
        fi
    else
        printf 'GTK theme mapping is not installed: %s\n' "$GTK_THEME" >&2
    fi
else
    printf 'GTK theme unchanged: no validated mapping for %s\n' "$THEME_NAME"
fi

# No current theme has a validated qt6ct color-scheme mapping.  If one is
# added to themes.toml later, accept it only when the existing qt6ct file is
# present; style, icons, fonts, palettes, and other settings remain untouched.
if [[ -n "$QT_COLOR_SCHEME" ]]; then
    QT6CT_CONF="$HOME/.config/qt6ct/qt6ct.conf"
    QT6CT_COLOR_FILE="/usr/share/qt6ct/colors/$QT_COLOR_SCHEME.conf"
    if [[ -f "$QT6CT_CONF" && -f "$QT6CT_COLOR_FILE" ]]; then
        if rewrite_ini_key "$QT6CT_CONF" color_scheme_path "$QT6CT_COLOR_FILE"; then
            printf 'Qt color scheme updated: %s\n' "$QT_COLOR_SCHEME"
        else
            printf 'Qt color scheme key unavailable\n' >&2
        fi
    else
        printf 'Qt mapping unavailable or uninstalled: %s\n' "$QT_COLOR_SCHEME" >&2
    fi
else
    printf 'Qt unchanged: no validated mapping for %s\n' "$THEME_NAME"
fi

printf 'global-appearance-apply: processed theme %s\n' "$THEME_NAME"
