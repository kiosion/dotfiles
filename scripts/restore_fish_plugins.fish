#!/usr/bin/env fish
set -p fish_function_path $__fish_config_dir/functions $__fish_data_dir/functions
set -l requested (string match -r '^[^\s]+$' <$__fish_config_dir/fish_plugins)
test (count $requested) -gt 0; or exit 1

if not functions -q fisher
    set -l installer (mktemp)
    or exit 1
    if not curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/4.4.5/functions/fisher.fish -o $installer
        command rm -f $installer
        exit 1
    end
    source $installer
    set -l result $status
    command rm -f $installer
    test $result -eq 0; or exit $result
end

fisher update </dev/null
set -l result $status
# Fisher rewrites this file even when a download fails.
printf '%s\n' $requested >$__fish_config_dir/fish_plugins
test $result -eq 0; or exit $result

for plugin in $requested
    if not contains -- (string lower -- $plugin) $_fisher_plugins
        printf 'Fish plugin was not installed: %s\n' $plugin >&2
        exit 1
    end
end
