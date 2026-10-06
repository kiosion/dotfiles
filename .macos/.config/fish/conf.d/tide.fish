# Tide's background shell must read the same settings as the interactive shell.
set -g tide_left_prompt_items identity pwd git go node rustc character
set -g tide_right_prompt_items
set -g tide_left_prompt_frame_enabled false
set -g tide_left_prompt_prefix ''
set -g tide_left_prompt_suffix ''
set -g tide_left_prompt_separator_same_color ' '
set -g tide_left_prompt_separator_diff_color ' '
set -g tide_right_prompt_frame_enabled false
set -g tide_right_prompt_prefix ''
set -g tide_right_prompt_suffix ''
set -g tide_prompt_add_newline_before true
set -g tide_prompt_pad_items false
set -g tide_prompt_transient_enabled false
set -g tide_prompt_min_cols 34

for item in identity pwd git go node rustc
    set -g tide_{$item}_bg_color normal
end
set -g tide_identity_color normal
set -g tide_character_icon '$'
set -g tide_character_vi_icon_default '$'
set -g tide_character_vi_icon_replace '$'
set -g tide_character_vi_icon_visual '$'
set -g tide_character_color green --bold
set -g tide_character_color_failure green --bold

set -g tide_pwd_color_anchors cyan --bold
set -g tide_pwd_color_dirs cyan --bold
set -g tide_pwd_color_truncated_dirs cyan --bold
set -g tide_pwd_icon
set -g tide_pwd_icon_home
set -g tide_pwd_icon_unwritable \U1F512

set -g tide_git_icon "on "\uE0A0
set -g tide_git_color_branch magenta --bold
set -g tide_git_bg_color_unstable normal
set -g tide_git_bg_color_urgent normal
set -g tide_git_truncation_length 36
for state in conflicted dirty operation staged stash untracked upstream
    set -g tide_git_color_{$state} red --bold
end

set -g tide_go_icon "via "\U1F439
set -g tide_go_color cyan --bold
set -g tide_node_icon "via "\U1F4A0
set -g tide_node_color green --bold
set -g tide_rustc_icon "via "\U1F980
set -g tide_rustc_color red --bold
