. "$HOME/.cargo/env"

update_go_path() {
    local go_version=$(asdf current golang | awk '{print $2}')
    local go_base_path="$HOME/.asdf/installs/golang/$go_version"

    if [ ! -d "$go_base_path" ]; then
        return
    fi

    local go_pkgs_path="$go_base_path/packages/bin"

    if [[ ":$PATH:" != *":$go_pkgs_path:"* ]]; then
        export PATH="$go_pkgs_path:$PATH"
    fi

    if [ -z "$GOBIN" ]; then
        export GOBIN="$go_pkgs_path"
    fi
}

update_go_path

