#!/bin/bash
# symlink config groups into a home dir.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: install.sh [--dry-run] [--home DIR] [--platform macos|linux]

symlinks selected config groups into DIR (default $HOME). On macOS,
files under .macos/ take precedence and replace a root file with the
same path. Existing file at targets are renamed to
<target>.backup.<timestamp>.

  -n, --dry-run    print actions
  --home DIR       specify target dir
  --platform NAME  link for NAME instead of detected platform
EOF
}

repo=$(cd "$(dirname "$0")" && pwd -P)
home=$HOME
dry_run=0
case "$(uname -s)" in
  Darwin) platform=macos ;;
  *) platform=linux ;;
esac

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run) dry_run=1 ;;
    --home) home=${2:?--home requires a directory}; shift ;;
    --platform) platform=${2:?--platform requires a name}; shift ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
  shift
done

case "$platform" in
  macos|linux) ;;
  *) echo "Unknown platform: $platform" >&2; exit 2 ;;
esac

# platform|group|target under home|source under repo, when differing from target
manifest() {
  cat <<'EOF'
all|shell|.bashrc|
all|shell|.config/fish/config.fish|
all|shell|.config/fish/fish_plugins|
all|shell|.config/starship/starship.toml|
linux|shell|.zshenv|
all|vim|.vimrc|
all|vim|.vim/coc-settings.json|
all|vim|.vim/colors/catppuccin_macchiato.vim|
all|vim|.vim/colors/catppuccin_mocha.vim|
macos|git|.gitconfig|work.gitconfig
linux|git|.gitconfig|
all|git|.gitignore|
all|tmux|.tmux.conf|.config/.tmux.conf
all|elixir|.iex.exs|
all|terminal|.config/alacritty|
macos|desktop|.config/skhd/skhdrc|
macos|desktop|.yabairc|.config/yabai/.yabairc
linux|desktop|.config/bspwm|
linux|desktop|.config/sxhkd|
linux|desktop|.config/polybar|
linux|desktop|.config/picom|
linux|desktop|.config/rofi|
linux|desktop|.local/share/rofi/themes|
linux|desktop|.config/wired|
linux|desktop|.config/hypr|
linux|x11|.Xresources|
linux|x11|.xinitrc|
linux|x11|.xprofile|
macos|editor|.config/zed/settings.json|
linux|editor|.config/Code/User/settings.json|
linux|editor|.config/doom|
EOF
}

entries() {
  manifest | while IFS='|' read -r plat group target source; do
    case "$plat" in
      all|"$platform") printf '%s|%s|%s\n' "$group" "$target" "${source:-$target}" ;;
    esac
  done
}

run() {
  if [ "$dry_run" -eq 1 ]; then
    echo "  + $*"
  else
    "$@"
  fi
}

resolve_source() {
  if [ "$platform" = macos ] && [ -e "$repo/.macos/$1" ]; then
    echo "$repo/.macos/$1"
  else
    echo "$repo/$1"
  fi
}

stamp=$(date +%Y%m%d%H%M%S)

link() {
  local src dst
  src=$(resolve_source "$2")
  dst=$home/$1
  if [ ! -e "$src" ]; then
    echo "skip    $1 (missing $src)"
    return
  fi
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok      $1"
    return
  fi
  if [ -d "$dst" ] && [ ! -L "$dst" ]; then
    echo "skip    $1 (existing directory, refusing to overwrite)"
    return
  fi
  if [ -e "$dst.backup.$stamp" ] || [ -L "$dst.backup.$stamp" ]; then
    echo "skip    $1 ($1.backup.$stamp already exists)"
    return
  fi
  run mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "backup  $1 -> $1.backup.$stamp"
    run mv "$dst" "$dst.backup.$stamp"
  fi
  echo "link    $1 -> $src"
  run ln -s "$src" "$dst"
}

install_packages() {
  if [ "$platform" = macos ]; then
    if ! command -v brew >/dev/null 2>&1; then
      echo 'Homebrew not found or installed.'
      return
    fi
    echo "brew install < .pkgs/brew/pkgs"
    [ "$dry_run" -eq 1 ] || xargs brew install < "$repo/.pkgs/brew/pkgs"
  else
    if ! command -v paru >/dev/null 2>&1; then
      echo 'paru not found or not installed.'
      return
    fi
    echo "paru -S --needed < .pkgs/paru/pkgs"
    [ "$dry_run" -eq 1 ] || awk '{print $1}' "$repo/.pkgs/paru/pkgs" | paru -S --needed -
  fi
}

group_names=$(entries | cut -d'|' -f1 | awk '!seen[$0]++')

echo "Platform $platform, symlinking to $home$( [ "$dry_run" -eq 1 ] && echo ' (dry-run)')"
echo
i=0
for group in $group_names; do
  i=$((i + 1))
  targets=$(entries | awk -F'|' -v g="$group" '$1 == g { printf "%s ", $2 }')
  printf '  %d) %-9s %s\n' "$i" "$group" "$targets"
done
echo
printf 'Groups to symlink (numbers, "all" or "none") [none]: '
read -r answer || answer=none

chosen=""
case "$answer" in
  all) chosen=$group_names ;;
  ""|none) ;;
  *)
    for n in $answer; do
      group=""
      case "$n" in
        *[!0-9]*|0) ;;
        *) group=$(echo "$group_names" | sed -n "${n}p") ;;
      esac
      if [ -z "$group" ]; then
        echo "Ignoring unknown choice: $n"
        continue
      fi
      chosen="$chosen $group"
    done
    ;;
esac

link_chosen() {
  for group in $chosen; do
    entries | while IFS='|' read -r g target source; do
      if [ "$g" = "$group" ]; then
        link "$target" "$source"
      fi
    done
  done
}

if [ -n "$chosen" ]; then
  echo
  echo "Plan for $home:"
  requested_dry_run=$dry_run
  dry_run=1
  link_chosen
  if [ "$requested_dry_run" -eq 0 ]; then
    echo
    printf 'Apply changes to %s? [y/N]: ' "$home"
    read -r answer || answer=
    case "$answer" in
      y|Y|yes) dry_run=0; echo; link_chosen ;;
      *) echo 'No changes made.' ;;
    esac
  fi
  dry_run=$requested_dry_run
fi

if [ "$platform" = linux ]; then
  echo
  echo "System files under .arch/ and .bsd/ not installed; review and handle manually with sudo."
fi

echo
printf 'Install packages from .pkgs? [y/N]: '
read -r answer || answer=
case "$answer" in
  y|Y|yes) install_packages ;;
esac

