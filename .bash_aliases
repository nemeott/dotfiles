#
# Helper Functions
#

# Check whether a command exists
#
# _command_exists <command>
_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Show a warning only in interactive shells
#
# _warn_missing <command> <error_context>
#
# Warning: <command> not found; skipping <error_context>
_warn_missing() {
    [[ $- == *i* ]] && printf 'Warning: %s not found; skipping %s\n' "$1" "$2" >&2
}

# Run a command if it exists, otherwise show a warning
#
# _run_if_exists <command> <error_context> <on_success...>
_run_if_exists() {
    local cmd="$1"
    local error_context="$2"
    shift 2
    if _command_exists "$cmd"; then
        "$@"
    else
        _warn_missing "$cmd" "$error_context"
    fi
}

#
# General Aliases
#

# Allow aliases to work with sudo
alias sudo='sudo '

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Create directory and enter it
#
# mkcd <directory>
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ls aliases
alias l='ls -l'
alias ll='ls -la'
alias la='ls -a'

_run_if_exists eza "l alias" alias l='eza -l --icons'
_run_if_exists eza "ll alias" alias ll='eza -la --icons'
_run_if_exists eza "la alias" alias la='eza -a --icons'

# Print path on newlines
alias path='echo "$PATH" | tr ":" "\n"'

# Add a resolved file or directory path to PATH
#
# addpath <path>
addpath() {
    if [[ ! -e "$1" ]]; then
        printf 'Warning: %s does not exist; skipping\n' "$1" >&2
        return 1
    fi

    local target
    target=$(readlink -f "$1") || return 1
    case ":$PATH:" in
    *":$target:"*) return 0 ;;
    *) export PATH="$PATH:$target" ;;
    esac
}

# Clipboard utilities
if _command_exists wl-copy; then
    alias cwd='pwd | wl-copy' # Copy working directory to clipboard

    # Print file path (follows symlinks to get absolute path)
    #
    # pfp <file>
    pfp() {
        readlink -f "$1"
    }
    # Copy file path to clipboard (follows symlinks to get absolute path)
    #
    # cfp <file>
    cfp() {
        pfp "$@" | wl-copy
    }
else
    _warn_missing wl-copy "cwd alias"
    _warn_missing wl-copy "cfp alias"
fi

# Kill process with fuzzy search
if _command_exists fzf; then
    fkill() {
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
else
    _warn_missing fzf "fkill function"
fi

# TODO: Remove when Zed copilot process duplication is fixed
# List all copilot language server instances
alias colist="ps aux | grep '[c]opilot-language-server'"
# Kill all but the most recent instance of the copilot language server
alias coclean="pgrep -f copilot-language-server | sort -n | head -n -1 | xargs -r kill"
# Kill all copilot language server processes
alias conuke="pkill -f copilot-language-server"

# Extract any archive
#
# extract <archive>
extract() {
    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) tar -xjf "$1" ;;
        *.tar.gz) tar -xzf "$1" ;;
        *.tar.xz) tar -xJf "$1" ;;
        *.tar.zst) tar -xf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar -xf "$1" ;;
        *.tbz2) tar -xjf "$1" ;;
        *.tgz) tar -xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.zst) tar -xf "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "Unknown archive: $1" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Publish current directory to GitHub using gh cli (supports optional --private flag)
#
# git-publish [--private]
if _command_exists gh; then
    git-publish() {
        local repo_name
        repo_name=$(basename "$(git rev-parse --show-toplevel)")

        local visibility="--public" # Default to public
        if [[ "$1" == "--private" ]]; then
            visibility="--private"
            echo "Creating private repository"
        else
            echo "Creating public repository"
        fi

        gh repo create "$repo_name" $visibility --source=. --remote=origin
    }
else
    _warn_missing gh "git-publish function"
fi

#
# Enhanced Command Aliases
#

# Replace default commands with enhanced versions
_run_if_exists bat "bat alias" alias cat='bat'
_run_if_exists batman "batman alias" alias man='batman'
_run_if_exists btop "btop alias" alias top='btop'
_run_if_exists eza "eza alias" alias ls='eza --icons'
_run_if_exists eza "eza alias" alias tree='eza --tree'
_run_if_exists fd "fd alias" alias find='fd'
_run_if_exists fzf "fzf alias" alias fzfp='fzf --preview "bat --color=always --style=numbers {}"' # Start fzf with bat preview
_run_if_exists rg "rg alias" alias grep='rg'

_run_if_exists powertop "ptop alias" alias ptop='powertop'
_run_if_exists fastfetch "ff alias" alias ff='fastfetch'
_run_if_exists systemctl-tui "sys alias" alias sys='systemctl-tui'
_run_if_exists lazygit "lg alias" alias lg='lazygit'

_run_if_exists zeditor "zed alias" alias zed='zeditor'
_run_if_exists zen-beta "zen alias" alias zen='zen-beta'

unset -f _command_exists
unset -f _warn_missing
unset -f _run_if_exists
