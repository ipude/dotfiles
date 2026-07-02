# NOT a full port of vim-surround. Only covers "wrap the whole command line
# in a character pair" — nothing like cs/ds, no text-object targeting.
# Opt-in: to use it, bind it yourself in fish_user_key_bindings.fish, e.g.
#   bind -M default yss surround-add
# then it'll prompt-read one char and wrap the current line with it.
function surround-add --description 'Minimal ys-like: wrap commandline in a char pair'
    read -n 1 -P '' char
    set -l pairs '(' ')' '[' ']' '{' '}' '<' '>'
    switch $char
        case '(' ')'
            set open '(' ; set close ')'
        case '[' ']'
            set open '[' ; set close ']'
        case '{' '}'
            set open '{' ; set close '}'
        case '<' '>'
            set open '<' ; set close '>'
        case '*'
            set open $char ; set close $char
    end
    commandline -i "$open"
    commandline -a "$close"
end
