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

# aliases
alias neofetch "neofetch --ascii_distro arch_old --disk_show '/' '/mnt/kepler/' '/mnt/tesla/' --cpu_temp C --block_range -1 -1"
#alias btw "neofetch"
alias l "ls -l --block-size=M"
alias la "ls -la --block-size=M"
alias md "mkdir -p"
alias wm-l "wmname LG3D"
alias wm-b "wmname bspwm"
alias img "tiv -a -r 0.5"
alias handbrake "ghb"
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
alias btrfs-snap="sudo btrfs subvolume snapshot / /snapshots/root_(date +'%Y-%m-%d_%H:%M')"

# setup zoxide
status --is-interactive; and zoxide init --cmd cd fish | source

# git aliases
function gitdiffremote
    set -l current_branch (git symbolic-ref --short HEAD)
    git diff $current_branch..origin/$current_branch
end

function gitmydiff
    set -l main_branch (git branch --all | grep -Eo '\b(main|master)\b' | head -n 1)
    if test -z "$main_branch"
        # echo in red
        echo (set_color red) "No main branch found..." (set_color normal)
        git fetch origin main:main
        git diff main...HEAD
    else
        set main_branch (string replace -r 'remotes/[^/]+/' '' $main_branch)
        git fetch origin $main_branch:$main_branch
        git diff $main_branch...HEAD
    end
end

set -gx OBJC_DISABLE_INITIALIZE_FORK_SAFETY "YES"

# set ssh agent correctly
fish_ssh_agent

# set ssh auth sock
set -gx SSH_AUTH_SOCK "/run/user/1000/yubikey-agent/yubikey-agent.sock"

# set starship config location
set -gx STARSHIP_CONFIG /home/kio/.config/starship/starship.toml

# set deno root
set -gx DENO_INSTALL $HOME/.deno

# set GOROOT w/ asdf
source ~/.asdf/plugins/golang/set-env.fish

# enable starship theme
status --is-interactive; and starship init fish | source

# init nvm
function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

status --is-interactive; and nvm use default > /dev/null

# force tty colour
set -gx FORCE_COLOR 1

# init rbenv
status --is-interactive; and rbenv init - fish | source

# init pyenv
status is-interactive; and pyenv init --path | source

# init ghcup / cabal
status is-interactive; and set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME

# init asdf-vm
status is-interactive; and source /opt/asdf-vm/asdf.fish

# functions
function add_to_path_if_not_exists
    for dir in $argv
        if not contains -- $dir $PATH
            set -gx PATH $dir:$PATH
        end
    end
end

function dedupe_path
    set -l deduped_path

    for dir in $PATH
        if not contains -- $dir $deduped_path
            set -a deduped_path $dir
        end
    end

    set -gx PATH $deduped_path
end

status is-interactive; and add_to_path_if_not_exists $HOME/.rbenv/shims $HOME/.ghcup/bin $HOME/.cabal/bin $HOME/.dvm/bin $HOME/.deno/bin $HOME/.dotnet/tools $HOME/.local/bin $HOME/.bin

status is-interactive; and dedupe_path

