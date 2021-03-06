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

# set ssh agent correctly
fish_ssh_agent
set -gx SSH_AUTH_SOCK "/usr/local/var/run/yubikey-agent.sock"

# set starship config location
set -gx STARSHIP_CONFIG /Users/kio/.config/starship/starship.toml

# enable starship theme
starship init fish | source

# aliases
alias btw "neofetch"
alias l "ls -l"
alias la "ls -la"
alias md "mkdir -p"
alias img "tiv -a -r 0.5"
alias handbrake "hbc"
alias pf "pfetch"
alias python3 "python"
alias py "python"

# yt-dlp
alias ytdl "yt-dlp -f bestvideo+bestaudio --merge-output-format mkv"

# load pyenv automatically
# status is-interactive; and pyenv init --path | source
# pyenv init - | source
# fish_add_path /usr/local/sbin
