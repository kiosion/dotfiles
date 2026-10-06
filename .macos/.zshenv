export TELEPORT_USE_LOCAL_SSH_AGENT=false
typeset -U path
path=("$HOME/.local/bin" "$HOME/.local/share/mise/shims" "$HOME/.cargo/bin" $path)
