function fish_prompt
    set -l last_status $status

    # Path: swap Termux's real home for ~, keep everything else full
    set -l display_path (string replace -r "^$HOME" "~" $PWD)
    set_color cyan
    echo -n $display_path
    set_color normal

    # Git info
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l branch (git symbolic-ref --short HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)

        echo -n "  "
        set_color magenta --bold
        echo -n "git:$branch"
        set_color normal

        # ahead/behind vs upstream
        set -l ahead_behind (git rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)
        if test -n "$ahead_behind"
            set -l behind (echo $ahead_behind | cut -f1)
            set -l ahead (echo $ahead_behind | cut -f2)
            if test "$ahead" -gt 0
                set_color green
                echo -n " ^$ahead"
            end
            if test "$behind" -gt 0
                set_color red
                echo -n " v$behind"
            end
            set_color normal
        end

        # staged / modified / untracked counts
        set -l staged (git diff --cached --numstat 2>/dev/null | count)
        set -l modified (git diff --numstat 2>/dev/null | count)
        set -l untracked (git ls-files --others --exclude-standard 2>/dev/null | count)

        if test $staged -eq 0 -a $modified -eq 0 -a $untracked -eq 0
            set_color green
            echo -n " [clean]"
        else
            if test $staged -gt 0
                set_color green
                echo -n " +$staged"
            end
            if test $modified -gt 0
                set_color yellow
                echo -n " !$modified"
            end
            if test $untracked -gt 0
                set_color blue
                echo -n " ?$untracked"
            end
        end
        set_color normal
    end

    # exit status of last command
    if test $last_status -ne 0
        set_color red --bold
        echo -n "  [exit $last_status]"
        set_color normal
    end

    echo ""
    set_color brblack
    echo -n "> "
    set_color normal
end
