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

# set ssh auth sock
set -gx SSH_AUTH_SOCK "/run/user/1000/yubikey-agent/yubikey-agent.sock"

# set starship config location
set -gx STARSHIP_CONFIG /home/kio/.config/starship/starship.toml

# enable starship theme
starship init fish | source

# add some common bins to PATH
if not contains -- $HOME/.bin $PATH
    set -gx PATH $HOME/.bin:$PATH
end
if not contains -- $HOME/.local/bin $PATH
    set -gx PATH $HOME/.local/bin:$PATH
end

# aliases
alias neofetch "neofetch --ascii_distro arch_old --disk_show '/' '/mnt/kepler/' '/mnt/tesla/' --cpu_temp C --block_range -1 -1"
alias btw "neofetch"
alias l "ls -l --block-size=M"
alias la "ls -la --block-size=M"
alias md "mkdir -p"
alias wm-l "wmname LG3D"
alias wm-b "wmname bspwm"
alias img "tiv -a -r 0.5"
alias handbrake "hbc"
alias pf "pfetch"
alias gpg-enc "gpg --encrypt --sign --armor -r hi@kio.dev"
alias b2 "b2-linux"
alias gits "git status"
alias gitc "git checkout"
alias gitl1 "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gitl2 "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
alias commita "git commit --amend --no-edit"
alias lastcommit "git show --stat --oneline HEAD"
alias autoc "OPENAI_API_KEY=$OPENAI_API_KEY auto-commit --review"
alias capy "bundle exec cucumber -p chrome -p mac-rc"
alias ytdl "yt-dlp -f bestvideo+bestaudio --merge-output-format mkv"
alias ydl "python ~/Nextcloud/Development/yiffer-dl/ydl.py"

# init nvm
function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

# force tty colour
set -gx FORCE_COLOR 1

# init rbenv
status --is-interactive; and rbenv init - fish | source
if not contains -- $HOME/.rbenv/shims $PATH
    set -gx PATH $HOME/.rbenv/shims:$PATH
end

# init pyenv
status is-interactive; and pyenv init --path | source

# init ghcup / cabal
status is-interactive; and set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
if not contains -- $HOME/.ghcup/bin $PATH
    set -gx PATH $HOME/.ghcup/bin:$PATH
end
if not contains -- $HOME/.cabal/bin $PATH
    set -gx PATH $HOME/.cabal/bin:$PATH
end

# if on tty1, launch startx automatically
#if status is-login
#    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
#        exec startx -- -keeptty
#    end
#end

# export PATH="$PATH:/home/kio/.bin"
