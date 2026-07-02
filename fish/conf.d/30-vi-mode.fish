if status is-interactive
    fish_vi_key_bindings
    set -g fish_escape_delay_ms 10
    set -g fish_cursor_default   block
    set -g fish_cursor_insert    line
    set -g fish_cursor_visual    block
    set -g fish_cursor_replace_one underscore
end
