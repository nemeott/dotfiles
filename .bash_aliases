# Show a warning only in interactive shells
_warn_missing() {
    [[ $- == *i* ]] && printf 'Warning: %s not found; skipping %s\n' "$1" "$2" >&2
}

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls aliases
if command -v eza >/dev/null 2>&1; then
    alias l='eza -l --icons'
    alias ll='eza -la --icons'
    alias la='eza -a --icons'
else
    alias l='ls -l'
    alias ll='ls -la'
    alias la='ls -a'
fi

# Allow aliases to work with sudo
alias sudo='sudo '

# TODO: Remove when Zed copilot process duplication is fixed
# List all copilot language server instances
alias colist="ps aux | grep '[c]opilot-language-server'"
# Kill all but the most recent instance of the copilot language server
alias coclean="pgrep -f copilot-language-server | sort -n | head -n -1 | xargs -r kill"
# Kill all copilot language server processes
alias conuke="pkill -f copilot-language-server"

# Create directory and enter it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Kill process with fuzzy search
fkill() {
    if ! command -v fzf >/dev/null 2>&1; then
        _warn_missing fzf "fkill"
        return 1
    fi

    local pid
    pid=$(ps -ef | sed 1d |
        fzf --multi \
            --header="Select processes to kill" \
            --preview="echo PID: {2}; echo CMD: {8..}" \
            --preview-window=up:3:wrap \
            --bind "change:top" |
        awk '{print $2}')
    if [[ -n "$pid" ]]; then
        echo "Killing $pid"
        echo "$pid" | xargs kill -9
    else
        printf 'No process selected, aborting\n' >&2
    fi
}

# Set alias only if the command exists
_alias_if() {
    # _alias_if <alias> <required_command> [alias_value...]
    local name="$1"
    local cmd="$2"
    shift 2

    # If the command exists, create the alias
    if command -v "$cmd" >/dev/null 2>&1; then
        alias "$name"="$*"
    else
        _warn_missing "$cmd" "alias for $name"
    fi
}

# Replace default commands with enhanced versions
# _alias_if <alias> <required_command> [alias_value...]
_alias_if cat bat 'bat'
_alias_if man batman 'batman'
_alias_if top btop 'btop'
_alias_if ls eza 'eza --icons'
_alias_if tree eza 'eza --tree'
_alias_if find fd 'fd'
_alias_if fzfp fzf 'fzf --preview "bat --color=always --style=numbers {}"' # Start fzf with bat preview
_alias_if grep rg 'rg'

_alias_if ptop powertop 'powertop'
_alias_if ff fastfetch 'fastfetch'
_alias_if sys systemctl-tui 'systemctl-tui'
_alias_if lg lazygit 'lazygit'

_alias_if zed zeditor 'zeditor'
_alias_if zen zen-beta 'zen-beta'

# Clipboard utilities
_alias_if cwd xclip 'pwd | xclip -selection clipboard' # Copy working directory to clipboard
if command -v xclip >/dev/null 2>&1; then
    cfp() {
        readlink -f "$1" | xclip -selection clipboard
    }
else
    _warn_missing xclip "cfp alias"
fi

unset -f _warn_missing
unset -f _alias_if
