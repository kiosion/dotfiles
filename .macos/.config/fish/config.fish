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

# Setup user PATHs
#eval (/opt/homebrew/bin/brew shellenv)
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

fish_add_path /usr/local/bin

fish_add_path --prepend $HOME/.local/share/mise/shims

fish_add_path $HOME/.cargo/bin

mise activate fish | source

# Set SSH agent socket to yubikey-agent
# TODO: Finish config of ~/.ssh/config for per-host socket use
set -gx SSH_AUTH_SOCK "/opt/homebrew//var/run/yubikey-agent.sock"

# Setup gpg
set -gx GPG_TTY (tty)

# Init starship
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
starship init fish | source

# Aliases
alias btw "neofetch"
alias l "ls -lh"
alias la "ls -lah"
alias md "mkdir -p"
alias img "tiv -a -r 0.5"
alias pf "pfetch"
alias python3 "python"
alias py "python"
alias gits "git status"
alias gitc "git checkout"
alias cls "clear"

if status --is-interactive
    # Init Zoxide (don't alias `cd` outside of interactive shells)
    zoxide init fish --cmd cd | source

    # B/c MacOS is ✨ special ✨ and doesn't allow disabling new shells' login message :)
    printf '\33c\e[3J'
end

