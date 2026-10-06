# Homebrew's vendor snippet runs before config.fish, including in scripts.
if not status is-interactive
    set -g MISE_FISH_AUTO_ACTIVATE 0
end
