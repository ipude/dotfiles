source ~/dotfiles/.zsh_prompt.zsh
source ~/dotfiles/.zsh_lock.zsh
# =============================================================================
# .zshrc — Fast, minimal, vi-first
# =============================================================================

# ----------------------------------------------------------------------------
# Path & Environment
# ----------------------------------------------------------------------------
# Add to your ~/.bashrc or ~/.zshrc
export GOROOT=$(go env GOROOT)
export GOPATH=$HOME/golang
export PATH=$PATH:$GOPATH/bin

export EDITOR='nvim'
export VISUAL='nvim'
export LESS='-R -F -X -i -M -W -q'

# ----------------------------------------------------------------------------
# Completion — load once, cache aggressively
# ----------------------------------------------------------------------------
autoload -Uz compinit

# Only rebuild completion dump once a day
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions'  format '%F{green}-- %d --%f'
zstyle ':completion:*:corrections'   format '%F{yellow}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages'      format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings'      format '%F{red}-- no matches found --%f'
zstyle ':completion:*:kill:*'        command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

unsetopt CORRECT CORRECT_ALL

# ----------------------------------------------------------------------------
# History
# ----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# ----------------------------------------------------------------------------
# Shell Options
# ----------------------------------------------------------------------------
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
unsetopt BEEP

# ----------------------------------------------------------------------------
# Vi Mode
# ----------------------------------------------------------------------------
bindkey -v
export KEYTIMEOUT=1

# Cursor shape: block in normal, beam in insert
function zle-keymap-select {
  case ${KEYMAP} in
    vicmd)      echo -ne '\e[1 q' ;;
    viins|main) echo -ne '\e[5 q' ;;
  esac
}
zle -N zle-keymap-select
function zle-line-init { echo -ne '\e[5 q' }
zle -N zle-line-init
echo -ne '\e[5 q'  # Beam on shell start

# Text objects: ci" da( yi{ etc. (built-in, no plugin needed)
autoload -Uz select-bracketed select-quoted
zle -N select-bracketed
zle -N select-quoted
for km in viopp visual; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
  for c in {a,i}{\',\",\`}; do
    bindkey -M $km $c select-quoted
  done
done

# Surround: cs"' ds( ys iw" S" (built-in)
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround    surround
zle -N change-surround surround
bindkey -M vicmd  cs change-surround
bindkey -M vicmd  ds delete-surround
bindkey -M vicmd  ys add-surround
bindkey -M visual  S add-surround

# Fix backspace not deleting past insert-mode entry point
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# Emacs-style line nav (useful in insert mode)
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^W' backward-kill-word
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# History search
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search    # Up arrow
bindkey '^[[B' down-line-or-beginning-search  # Down arrow
bindkey '^P'   up-line-or-beginning-search
bindkey '^N'   down-line-or-beginning-search
bindkey '^R'   history-incremental-search-backward
bindkey '^S'   history-incremental-search-forward

# ----------------------------------------------------------------------------
# Directory Navigation
# ----------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# ----------------------------------------------------------------------------
# Zoxide (smart cd)
# ----------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# ----------------------------------------------------------------------------
# ls — eza or fallback, no duplicates
# ----------------------------------------------------------------------------
if command -v eza &>/dev/null; then
  alias ls='eza --long --all --header --icons --git --group-directories-first --no-permissions --no-user --no-time'
  alias lt='eza --tree --level=2 --icons --git'
  alias ltd='eza --tree --level=2 --icons --only-dirs'
else
  alias ls='ls -lAh --color=auto --group-directories-first'
  alias lt='tree -L 2'
  alias ltd='tree -L 2 -d'
fi
alias ll='ls'
alias la='ls'

# ----------------------------------------------------------------------------
# FZF
# ----------------------------------------------------------------------------
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"

  export FZF_DEFAULT_OPTS="
    --height 40% --layout=reverse --border --inline-info
    --color=fg:#d0d0d0,bg:#1c1c1c,hl:#5f87af
    --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
    --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
    --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
  "

  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
fi

# ----------------------------------------------------------------------------
# Better core tools (if installed)
# ----------------------------------------------------------------------------
# command -v bat &>/dev/null && alias cat='bat --style=auto'
command -v fd  &>/dev/null && alias find='fd'
command -v rg  &>/dev/null && alias grep='rg' || alias grep='grep --color=auto'

alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ----------------------------------------------------------------------------
# Safety & Quality of Life
# ----------------------------------------------------------------------------
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ----------------------------------------------------------------------------
# Git
# ----------------------------------------------------------------------------
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# Repo clones
alias GA='git clone --depth 1 https://github.com/anoninus/arch-nvim.git .'
alias GR='git clone --depth 1 https://github.com/anoninus-bro/config.git .'

# ----------------------------------------------------------------------------
# Misc Aliases
# ----------------------------------------------------------------------------
alias n='nvim'
alias b='nvim'
alias rc='nvim ~/.zshrc'
alias rel='source ~/.zshrc'
alias cl='clear'
alias ex='exit'
alias zj='zellij'
alias di='sdcv'
alias myip='curl -s ifconfig.me'
alias ..='cd ..'

# ----------------------------------------------------------------------------
# Plugins — syntax highlighting (load second-to-last)
# ----------------------------------------------------------------------------
[[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ----------------------------------------------------------------------------
# Plugins — autosuggestions (load last before prompt)
# ----------------------------------------------------------------------------
if [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
  bindkey '^ '    autosuggest-accept   # Ctrl+Space
  bindkey '^[[F'  autosuggest-accept   # End key
fi

# ----------------------------------------------------------------------------
# Prompt — Starship (always last)
# ----------------------------------------------------------------------------
command -v starship &>/dev/null && eval "$(starship init zsh)"

# =============================================================================
# End
# =============================================================================

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin


#------------
# Custom
#------------ 


mkcd() { mkdir -p "$1" && cd "$1" }
# Add to ~/.zshrc

sw() {
    local target="$HOME/.termux/colors.properties"
    local themes="$HOME/.termux/themes"

    if grep -q '222436' "$target" 2>/dev/null; then
        \cp "$themes/catppuccin-latte.properties" "$target"
        echo "→ Catppuccin Latte"
    else
        \cp "$themes/tokyonight-moon.properties" "$target"
        echo "→ Tokyonight Moon"
    fi

    termux-reload-settings
}

alias gocl="go clean -cache"

# view docs of any lib 
# viewdocs github.com/urfave/@v3
viewdocs() {
    local pkg="$1"
    local dir=$(fd --type d --glob "*$(basename "$pkg")*" "$(go env GOMODCACHE)" | head -1)
    if [ -d "$dir" ]; then
        cd "$dir" && ~/go/bin/pkgsite -open .
    else
        echo "Module not found. Run: go get $pkg"
    fi
}

# stdlib
std() { pkgsite -open "$(go env GOROOT)/src"; }

alias wk="NVIM_APPNAME=work nvim"
export PATH="$HOME/.cargo/bin:$PATH"
export TMPDIR=/data/data/com.termux/files/usr/tmp
