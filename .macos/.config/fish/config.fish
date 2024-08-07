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

# Setup homebrew
eval (/opt/homebrew/bin/brew shellenv)

fish_add_path /usr/local/bin

# Set SSH agent socket to yubikey-agent
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

# Source cargo bin
fish_add_path $HOME/.cargo/bin

# Init nvm
set -gx NVM_DIR $HOME/.nvm
function nvm
  bass source /opt/homebrew/opt/nvm/nvm.sh --no-use ';' nvm $argv
end

if status --is-login
    nvm use default > /dev/null
end

# Init asdf
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Query current ver of Go set in asdf so we can use its /lib
function update_go_path
    set -l go_version (asdf current golang | awk '{print $2}')
    set -l go_base_path $HOME/.asdf/installs/golang/$go_version
    set -l go_packages_path $go_base_path/packages/bin
    
    if not contains $go_packages_path $PATH
        fish_add_path $go_packages_path
    end
    
    if not set -q GOBIN
        set -gx GOBIN $go_packages_path
    end
end

update_go_path

if status --is-interactive
    # Init Zoxide (don't alias `cd` outside of interactive shells)
    zoxide init fish --cmd cd | source

    # B/c MacOS is ✨ special ✨ and doesn't allow disabling new shells' login message :)
    printf '\33c\e[3J'
end

