if command -v zoxide >/dev/null
    zoxide init fish --cmd cd | source
end
if command -v eza >/dev/null
    alias ls 'eza --long --all --header --icons --git --group-directories-first --no-permissions --no-user --no-time'
    alias lt 'eza --tree --level=2 --icons --git'
    alias ltd 'eza --tree --level=2 --icons --only-dirs'
else
    alias ls 'ls -lAh --color=auto --group-directories-first'
    alias lt 'tree -L 2'
    alias ltd 'tree -L 2 -d'
end
alias ll ls
alias la ls
if command -v fzf >/dev/null
    fzf --fish | source

    set -gx FZF_DEFAULT_OPTS "
    --height 40% --layout=reverse --border --inline-info
    --color=fg:#d0d0d0,bg:#1c1c1c,hl:#5f87af
    --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
    --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
    --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
    "

    if command -v fd >/dev/null
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
        set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
        set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
    end
end
command -v fd >/dev/null; and alias find fd
if command -v rg >/dev/null
    alias grep rg
else
    alias grep 'grep --color=auto'
end
alias fgrep 'fgrep --color=auto'
alias egrep 'egrep --color=auto'
alias rm 'rm -i'
alias cp 'cp -i'
alias mv 'mv -i'
alias mkdir 'mkdir -pv'
