if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

export TELEPORT_USE_LOCAL_SSH_AGENT=false

case $- in
    *i*)
        if command -v mise >/dev/null 2>&1; then
            eval "$(mise activate bash)"
        fi
        ;;
esac
