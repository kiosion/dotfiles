function _tide_item_identity
    set -l user_color blue
    test "$EUID" = 0; and set user_color red
    _tide_print_item identity (set_color --bold $user_color)$USER(set_color normal)' in'
end
