function tm --description 'Create, attach, or choose a tmux session'
    if test (count $argv) -gt 1
        printf 'usage: tm [session]\n' >&2
        return 2
    end

    if not set -q argv[1]
        if set -q TMUX
            command tmux choose-tree -Zs
        else if command tmux has-session 2>/dev/null
            command tmux attach-session \; choose-tree -Zs
        else
            command tmux new-session -A -s work -c "$PWD"
        end
        return $status
    end

    set -l session $argv[1]
    if test -z "$session"; or string match -rq '[:.]' -- "$session"
        printf 'tm: session names must be nonempty and cannot contain . or :\n' >&2
        return 2
    end

    if set -q TMUX
        if not command tmux has-session -t "=$session" 2>/dev/null
            command tmux new-session -d -s "$session" -c "$PWD"; or return $status
        end
        command tmux switch-client -t "=$session"
    else
        command tmux new-session -A -s "$session" -c "$PWD"
    end
end
