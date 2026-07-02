if status is-interactive
    set -g fish_color_normal        c8d3f5
    set -g fish_color_command       82aaff --bold   # executables — bold blue
    set -g fish_color_keyword       c099ff           # if/for/function/etc
    set -g fish_color_quote         c3e88d           # strings
    set -g fish_color_redirection   86e1fc
    set -g fish_color_end           86e1fc           # ; | statement separators
    set -g fish_color_error         ff757f --bold    # invalid command / typo
    set -g fish_color_param         c8d3f5           # plain positional args
    set -g fish_color_option        ffc777           # -x / --flags
    set -g fish_color_operator      fca7ea           # $vars, *, ~, {a,b}
    set -g fish_color_escape        ff966c
    set -g fish_color_comment       636da6
    set -g fish_color_valid_path    --underline 4fd6be
    set -g fish_color_selection     --background=2f334d
    set -g fish_color_search_match  --background=3b4261
    set -g fish_color_history_current --bold
    set -g fish_color_cancel        ff757f
    set -g fish_color_autosuggestion 545c7e
end

