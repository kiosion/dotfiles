if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Set path
set PATH "$HOME/Library/Application Support/Übersicht/widgets/landscape/landscape" "/usr/local/bin/landscape" $PATH

# Configure omf theme
set -g theme_display_time yes
set -g theme_display_group no
set -g theme_color_time brblack
set -g theme_display_time_format '+[%H:%M:%S]'

# Load pyenv automatically
status is-interactive; and pyenv init --path | source
pyenv init - | source
fish_add_path /usr/local/sbin
