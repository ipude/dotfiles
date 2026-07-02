# ═══════════════════════════════════════════════
# 🔒 NVIM CONFIG FORTRESS — Zsh Shell Guard
# ═══════════════════════════════════════════════

_nvim_fortress_guard() {
  local cmd="$1"
  local full_cmd="$2"  # full expanded command line

  # ── Paths to protect ──────────────────────────
  local -a PROTECTED_PATHS=(
    "$HOME/.config/nvim"
    "$HOME/.local/share/nvim"
    "$HOME/.local/state/nvim"
    "$HOME/.cache/nvim"
  )

  # ── Dangerous commands to intercept ───────────
  local -a KILL_CMDS=(
    "rm" "rmdir" "unlink" "shred" "wipe" "srm"
    "ncdu" "ranger" "nnn" "lf" "broot"        # TUI file managers
    "find"                                      # find -delete / -exec rm
    "xargs"                                     # xargs rm
    "chmod" "chown"                             # permission nukes
    "mv"                                        # moving away = effective delete
    "dd"                                        # dd if=/dev/zero ...
    "truncate"
    "perl" "python3" "python" "ruby" "node"     # scripting engines
    "bash" "sh" "zsh" "dash"                   # subshells with inline scripts
  )

  # ── Check if CWD is inside a protected path ───
  for ppath in "${PROTECTED_PATHS[@]}"; do
    if [[ "$PWD" == "$ppath"* ]]; then
      echo "🔒 FORTRESS: CWD is inside protected path → $ppath"
      echo "🚨 Killing shell to prevent accidental destruction..."
      sleep 0.3
      kill -9 $$
      return
    fi
  done

  # ── Scan the full command line for protected paths ──
  for ppath in "${PROTECTED_PATHS[@]}"; do
    if [[ "$full_cmd" == *"$ppath"* ]]; then
      echo "🔒 FORTRESS: Command references protected path → $ppath"
      echo "   CMD: $full_cmd"
      echo "🚨 BLOCKED."
      kill -9 $$
      return
    fi
  done

  # ── Block dangerous commands if ANY protected path ──
  # ── is reachable from current context ──────────────
  local base_cmd="${cmd%% *}"          # first word only
  base_cmd="${base_cmd##*/}"           # strip path prefix (e.g. /bin/rm → rm)

  for danger in "${KILL_CMDS[@]}"; do
    if [[ "$base_cmd" == "$danger" ]]; then
      # Secondary check: does the full command touch protected paths?
      for ppath in "${PROTECTED_PATHS[@]}"; do
        if [[ "$full_cmd" == *"$ppath"* || "$full_cmd" == *".config/nvim"* || "$full_cmd" == *"nvim"* ]]; then
          echo "🔒 FORTRESS: Dangerous command '$danger' near protected path."
          echo "   Blocked: $full_cmd"
          kill -9 $$
          return
        fi
      done
    fi
  done
}

# ── Hook into every command before execution ────
autoload -U add-zsh-hook
preexec_functions+=(_nvim_fortress_guard)

# ── Block CWD changes INTO protected dirs ───────
_nvim_fortress_chpwd() {
  local -a PROTECTED_PATHS=(
    "$HOME/.config/nvim"
    "$HOME/.local/share/nvim"
    "$HOME/.local/state/nvim"
    "$HOME/.cache/nvim"
  )
  for ppath in "${PROTECTED_PATHS[@]}"; do
    if [[ "$PWD" == "$ppath"* ]]; then
      echo "🔒 FORTRESS: Blocked entry into $PWD"
      cd "$OLDPWD" 2>/dev/null || cd "$HOME"
    fi
  done
}
add-zsh-hook chpwd _nvim_fortress_chpwd

echo "🏰 Nvim Fortress active — $(echo ${PROTECTED_PATHS[@]} | tr ' ' '\n' | wc -l | tr -d ' ') paths protected"
