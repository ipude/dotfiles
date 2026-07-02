# ─────────────────────────────────────────────
#  Minimal ZSH Prompt — TokyoNight Moon
#  Features: smart path, git[*], bold, fast
# ─────────────────────────────────────────────

# ── TokyoNight Moon palette (256-color fallback + truecolor) ──
# Using zsh prompt escape sequences for bold + color
# %B...%b = bold, %F{#hex}...%f = foreground color

# ── Git status function ──
_git_prompt() {
  # Bail fast if not in a git repo
  command git rev-parse --git-dir &>/dev/null || return

  local branch dirty

  # Get branch/tag/commit
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null \
           || command git describe --tags --exact-match HEAD 2>/dev/null \
           || command git rev-parse --short HEAD 2>/dev/null)

  # Check for any tracked or untracked changes
  if ! command git diff --quiet 2>/dev/null \
     || ! command git diff --cached --quiet 2>/dev/null \
     || [[ -n $(command git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    dirty="*"
  fi

  # git[branch*]  — teal branch name, red * if dirty
  if [[ -n $dirty ]]; then
    echo " %B%F{#ff757f}git[%F{#4fd6be}${branch}%F{#ff757f}${dirty}]%f%b"
  else
    echo " %B%F{#636da6}git[%F{#4fd6be}${branch}]%f%b"
  fi
}

# ── Smart path (Termux-aware) ──
_smart_path() {
  local p="$PWD"

  # Termux: $PREFIX is usually /data/data/com.termux/files/usr
  # Replace it before replacing HOME so PREFIX inside HOME works
  if [[ -n "$PREFIX" && "$p" == "$PREFIX"* ]]; then
    p="\$PREFIX${p#$PREFIX}"
  elif [[ "$p" == "$HOME"* ]]; then
    p="~${p#$HOME}"
  fi

  echo "$p"
}

# ── Prompt assembly ──
setopt PROMPT_SUBST

PROMPT=$'%B%F{#82aaff}$(_smart_path)%f%b$(_git_prompt)\n%F{#c3e88d}❯%f%b '

# ── Right prompt: exit code badge (only on failure) ──
RPROMPT='%(?.%F{#636da6}.%B%F{#ff757f}✘ %?%f%b)'

# ─────────────────────────────────────────────
#  Optional quality-of-life (uncomment as needed)
# ─────────────────────────────────────────────

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# Better completion
autoload -Uz compinit && compinit -u

# Colors for ls
if [[ "$OSTYPE" == "linux"* ]]; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'    # macOS / BSD
fi

