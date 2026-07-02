set -g __fortress_protected_paths \
    "$HOME/.config/nvim" \
    "$HOME/.local/share/nvim" \
    "$HOME/.local/state/nvim" \
    "$HOME/.cache/nvim"

set -g __fortress_kill_cmds \
    rm rmdir unlink shred wipe srm \
    ncdu ranger nnn lf broot \
    find xargs chmod chown mv dd truncate \
    perl python3 python ruby node \
    bash sh zsh dash

function _nvim_fortress_guard --on-event fish_preexec
    set -l full_cmd $argv[1]
    set -l base_cmd (string split -- ' ' $full_cmd)[1]
    set base_cmd (path basename -- $base_cmd)

    # CWD inside a protected path
    for ppath in $__fortress_protected_paths
        if string match -q -- "$ppath*" $PWD
            echo "🔒 FORTRESS: CWD is inside protected path → $ppath"
            echo "🚨 Killing shell to prevent accidental destruction..."
            sleep 0.3
            kill -9 $fish_pid
            return
        end
    end

    # Full command line references a protected path
    for ppath in $__fortress_protected_paths
        if string match -q -- "*$ppath*" $full_cmd
            echo "🔒 FORTRESS: Command references protected path → $ppath"
            echo "   CMD: $full_cmd"
            echo "🚨 BLOCKED."
            kill -9 $fish_pid
            return
        end
    end

    if contains -- $base_cmd $__fortress_kill_cmds
        for ppath in $__fortress_protected_paths
            if string match -q -- "*$ppath*" $full_cmd; or string match -q -- "*.config/nvim*" $full_cmd; or string match -q -- "*nvim*" $full_cmd
                echo "🔒 FORTRESS: Dangerous command '$base_cmd' near protected path."
                echo "   Blocked: $full_cmd"
                kill -9 $fish_pid
                return
            end
        end
    end
end

function _nvim_fortress_chpwd --on-variable PWD
    for ppath in $__fortress_protected_paths
        if string match -q -- "$ppath*" $PWD
            echo "🔒 FORTRESS: Blocked entry into $PWD"
            cd $OLDPWD 2>/dev/null; or cd $HOME
        end
    end
end

if status is-interactive
    echo "🏰 Nvim Fortress active — "(count $__fortress_protected_paths)" paths protected"
end

