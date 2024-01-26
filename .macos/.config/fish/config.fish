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

# setup homebrew
eval (/opt/homebrew/bin/brew shellenv)

# setup ssh agent correctly
set -gx SSH_AUTH_SOCK "/opt/homebrew//var/run/yubikey-agent.sock"

# setup gpg
set -gx GPG_TTY (tty)

# setup starship
set -gx STARSHIP_CONFIG /Users/kio/.config/starship/starship.toml
starship init fish | source

# aliases
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

# yt-dlp
alias ytdl "yt-dlp -f bestvideo+bestaudio --merge-output-format mkv"

# source cargo env
set PATH $HOME/.cargo/bin $PATH

# init nvm
set -gx NVM_DIR $HOME/.nvm

function nvm
  bass source /opt/homebrew/opt/nvm/nvm.sh --no-use ';' nvm $argv
end

if status --is-login
    nvm use default > /dev/null
end

# because macos is special and doesn't allow hiding the login message in new shells :)))))
printf '\33c\e[3J'

