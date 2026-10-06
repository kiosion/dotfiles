#
#________/\\\\\_____________________/\\\_________        
# ______/\\\///_____________________\/\\\_________       
#  _____/\\\_______/\\\______________\/\\\_________      
#   __/\\\\\\\\\___\///___/\\\\\\\\\\_\/\\\_________     
#    _\////\\\//_____/\\\_\/\\\//////__\/\\\\\\\\\\__    
#     ____\/\\\______\/\\\_\/\\\\\\\\\\_\/\\\/////\\\_   
#      ____\/\\\______\/\\\_\////////\\\_\/\\\___\/\\\_  
#       ____\/\\\______\/\\\__/\\\\\\\\\\_\/\\\___\/\\\_ 
#        ____\///_______\///__\//////////__\///____\///__
#
# Configuration options for fish shell
set -gx AWS_DEFAULT_REGION "us-east-1"

set -g fish_greeting ""

# Setup user PATHs
fish_add_path --path $HOME/.local/bin /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set -gx GHCUP_INSTALL_BASE_PREFIX $HOME
fish_add_path --path $HOME/.cabal/bin $GHCUP_INSTALL_BASE_PREFIX/.ghcup/bin

# Teleport local dev helpers
# TP_SRC is what tpb builds from; point it at a worktree to build that branch.
set -gx TELEPORT_USE_LOCAL_SSH_AGENT false
set -gx TP_SRC "$HOME/Dev/gravitational/core"
set -gx TP_CONF "$HOME/Dev/teleport-local/conf"
# Don't clobber a universal TP_BIN set by `tpv set`.
set -q TP_BIN; or set -gx TP_BIN "$HOME/Dev/teleport-local/bin/teleport"

if not status is-interactive
    fish_add_path --path --move $HOME/.local/share/mise/shims
    return
end

isatty stdin; and set -gx GPG_TTY (tty)

# Abbrs
abbr -a la "ls -lah"
abbr -a md "mkdir -p"
abbr -a gits "git status"
abbr -a gitc "git checkout"
abbr -a gitca "git commit --amend"
abbr -a gitcan "git commit --amend --no-edit"
abbr pf "pfetch"
abbr python3 "python"
abbr py "python"

if command -q zoxide
    zoxide init fish --cmd cd | source
end
