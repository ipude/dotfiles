function fish_user_key_bindings
    # Backspace past the insert-mode entry point (your zsh viins fix).
    # Fish's default already does this, kept explicit to guarantee parity.
    bind -M insert backspace backward-delete-char
    bind -M insert \cH        backward-delete-char

    # Emacs-style line nav while in insert mode
    bind -M insert \ca beginning-of-line
    bind -M insert \ce end-of-line
    bind -M insert \cw backward-kill-word
    bind -M insert \cu backward-kill-line
    bind -M insert \ck kill-line

    # History search — up/down and ^P/^N do prefix search (native default,
    # rebound here only to guarantee it in both insert and default mode)
    bind -M insert \cp history-search-backward
    bind -M insert \cn history-search-forward
    bind -M default \cp history-search-backward
    bind -M default \cn history-search-forward

    # ^R incremental search. NOT binding ^S: on most terminals it's caught
    # by tty flow control (XOFF) before fish ever sees it and freezes all
    # output until Ctrl+Q (XON) is pressed — that's what just happened to
    # you. If you actually want ^S to work, disable flow control instead:
    # run `stty -ixon` in your terminal's own startup (not fish's), then
    # uncomment the line below.
    bind -M insert \cr history-pager
    # bind -M insert \cs history-pager

    # Autosuggestion accept — End key only. Dropped the Ctrl+Space bind:
    # it maps to a raw NUL byte, which is safer left unbound (fish/terminals
    # don't handle it consistently). Right arrow / Ctrl+F already accept by
    # default, so you're not losing the feature, just the extra shortcut.
    bind -M insert \e\[F accept-autosuggestion  # End key
end
