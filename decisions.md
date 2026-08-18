# DWM-Sky Architecture Decisions

## 1. Repository & Dotfiles Separation

- `~/git-repos/dwm-sky` is the authoritative DWM source code and project repository.
- `~/dotfiles/dwm` is the GNU Stow package managing user configurations linked to `$HOME`.
- The two trees are kept distinct. Stow configurations are not folded into the C source repository, and the Stow package is not treated as a source repo.

## 2. Binary Stability

- The installed `/usr/local/bin/dwm` binary is preserved and working.
- We do not rebuild or replace `/usr/local/bin/dwm` during configuration and script cleanup phases.

## 3. Canonical Global Theme Architecture

- `~/.config/dwm-sky/themes.toml` is the single authoritative source of truth for themes.
- Changing the active theme in Control Center (`SUPER+F1` -> Appearance -> Select Theme) or editing `themes.toml` updates the file in-place (`cat` / `sed --follow-symlinks`) to preserve Stow symlinks.
- Inotify in DWM detects the file close/write and triggers `theme-apply.sh` to update DWM colors, Polybar (`colors.ini`), Rofi, Alacritty, Kitty, and Ghostty.
- GTK and Qt integration is handled by `global-appearance-apply.sh`, which only applies explicitly validated theme mappings (e.g. Nord -> Nordic) and preserves styles, fonts, icons, palettes, and cursor settings.
- `xsettingsd` is kept inactive.

## 4. Independent Cursor Configuration

- Mouse cursor theme (`Bibata-Modern-Ice`) and size (`24`) are configured via `~/.config/dwm-sky/cursor.Xresources` and GTK settings, and are completely independent from theme palette switching.

## 5. Symlink Safety

- All automated config modifications (in `theme-apply.sh`, `global-appearance-apply.sh`, and `dwm-controlcenter`) must preserve symlinks using `--follow-symlinks` with `sed` or temporary file copy via `cat $tmp > $target`.

## 6. Generated & Runtime Files

- Generated theme artifacts (such as `active-theme.toml`, `active-theme.conf`, `colors.ini`, and `theme-env.sh`) are unmanaged runtime state and are not tracked in Stow.

## 7. Legacy Titus Preservation

- Legacy Titus configuration (`~/.local/share/dwm-titus`) is retained for reference and rollback, while all active runtime paths strictly resolve to `dwm-sky`.
