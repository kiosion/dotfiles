function dotfiles_async_prompt
    status is-interactive; or return 1
    status is-no-job-control; and return 1
    set -q __dotfiles_prompt_dir; and return 0
    test "$fish_transient_prompt" != 1; or return 1
    functions -q fish_prompt; or return 1
    functions --handlers --handlers-type signal | string match -qr '^SIGUSR1 '; and return 1

    set -l prompt_dir (command mktemp -d -t dotfiles-prompt.XXXXXXXX)
    test -d "$prompt_dir"; or return 1
    set -g __dotfiles_prompt_dir $prompt_dir
    set -g __dotfiles_prompt_generation 0
    set -g __dotfiles_prompt_active 0
    set -g __dotfiles_prompt_fish (status fish-path)

    function __dotfiles_prompt_cancel --on-event fish_preexec
        set -g __dotfiles_prompt_active 0
        if set -q __dotfiles_prompt_worker
            # Keep ownership in Fish's job table until the worker is acknowledged.
            if jobs -q $__dotfiles_prompt_worker
                disown $__dotfiles_prompt_worker
                command kill -TERM -- -$__dotfiles_prompt_worker 2>/dev/null
            end
            set -e __dotfiles_prompt_worker
        end
        if set -q __dotfiles_prompt_file
            command rm -f -- "$__dotfiles_prompt_file.pending" "$__dotfiles_prompt_file.ready" \
                "$__dotfiles_prompt_file.failed" "$__dotfiles_prompt_file.right"
        end
    end

    function __dotfiles_prompt_start --on-event fish_prompt
        set -l previous_pipeline $pipestatus
        set -l previous_status $status
        set -l duration "$CMD_DURATION$cmd_duration"
        __dotfiles_prompt_cancel
        for mode in (bind --list-modes)
            if bind --preset --mode $mode ctrl-d 2>/dev/null | string match -qr ' delete-or-exit$'
                bind --preset --mode $mode ctrl-d __dotfiles_prompt_delete_or_exit
            end
        end
        set -g __dotfiles_prompt_generation (math $__dotfiles_prompt_generation + 1)
        set -g __dotfiles_prompt_file $__dotfiles_prompt_dir/$__dotfiles_prompt_generation
        set -g __dotfiles_prompt_active 1
        set -l keymap insert
        switch "$fish_key_bindings"
            case fish_hybrid_key_bindings fish_vi_key_bindings fish_helix_key_bindings
                set keymap "$fish_bind_mode"
        end
        set -l job_count (jobs -g 2>/dev/null | count)
        set -g __dotfiles_prompt_args --terminal-width="$COLUMNS" --status=$previous_status \
            --pipestatus="$previous_pipeline" --cmd-duration="$duration" --keymap=$keymap --jobs=$job_count
        if set -q __dotfiles_prompt_failed
            set -g __dotfiles_prompt_active 0
            return
        end
        set -g __dotfiles_prompt_right ''
        set -g __dotfiles_prompt_text (command starship prompt --profile loading $__dotfiles_prompt_args | string collect -N)
        if test $pipestatus[1] -ne 0
            set -g __dotfiles_prompt_failed 1
            set -g __dotfiles_prompt_active 0
            return
        end

        set -l restore_job_control 0
        if status is-interactive-job-control
            status job-control full
            set restore_job_control 1
        end
        command $__dotfiles_prompt_fish --no-config --private -c '
            if command starship prompt $argv[3..] >$argv[1].pending
                if command starship prompt --right $argv[3..] >$argv[1].right
                    command mv -- $argv[1].pending $argv[1].ready; or exit
                else
                    printf "" >$argv[1].failed; or exit
                end
            else
                printf "" >$argv[1].failed; or exit
            end
            command kill -s USR1 $argv[2] 2>/dev/null; or exit
            for attempt in (seq 100)
                if not test -f $argv[1].ready; and not test -f $argv[1].failed
                    exit
                end
                command sleep 0.05
            end
        ' $__dotfiles_prompt_file $fish_pid $__dotfiles_prompt_args </dev/null >/dev/null 2>/dev/null &
        set -g __dotfiles_prompt_worker $last_pid
        if test $restore_job_control = 1
            status job-control interactive
        end
        set -l group (jobs -g $__dotfiles_prompt_worker 2>/dev/null)
        if test "$group" != "$__dotfiles_prompt_worker"
            command kill -TERM $__dotfiles_prompt_worker 2>/dev/null
            set -e __dotfiles_prompt_worker
            set -g __dotfiles_prompt_active 0
        end
    end

    function __dotfiles_prompt_ready --on-signal USR1
        test "$__dotfiles_prompt_active" = 1; or return
        if test -f "$__dotfiles_prompt_file.failed"
            set -g __dotfiles_prompt_failed 1
            set -g __dotfiles_prompt_active 0
        else if test -f "$__dotfiles_prompt_file.ready"
            set -g __dotfiles_prompt_text (string collect -N <"$__dotfiles_prompt_file.ready")
            set -g __dotfiles_prompt_right (string collect -N <"$__dotfiles_prompt_file.right")
        else
            return
        end
        if set -q __dotfiles_prompt_worker; and jobs -q $__dotfiles_prompt_worker
            disown $__dotfiles_prompt_worker
        end
        set -e __dotfiles_prompt_worker
        command rm -f -- "$__dotfiles_prompt_file.ready" "$__dotfiles_prompt_file.failed" \
            "$__dotfiles_prompt_file.pending" "$__dotfiles_prompt_file.right"
        commandline -f repaint
    end

    function __dotfiles_prompt_cleanup --on-event fish_exit
        __dotfiles_prompt_cancel
        command rmdir -- "$__dotfiles_prompt_dir" 2>/dev/null
    end

    function __dotfiles_prompt_delete_or_exit
        # Fish checks for running jobs before emitting fish_exit for Ctrl-D.
        if test -z (commandline --current-buffer | string collect)
            __dotfiles_prompt_cancel
        end
        commandline -f delete-or-exit
    end

    function fish_prompt
        if test "$__dotfiles_prompt_active" = 1
            printf '%s' "$__dotfiles_prompt_text"
        else
            command starship prompt $__dotfiles_prompt_args
        end
    end

    function fish_right_prompt
        if test "$__dotfiles_prompt_active" = 1
            printf '%s' "$__dotfiles_prompt_right"
        else
            command starship prompt --right $__dotfiles_prompt_args
        end
    end
end
