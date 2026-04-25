#
# Helper Functions
#

# Check whether a command exists
#
# _command_exists <command>
_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Show a warning only in interactive shells, with suppression after 3 messages
#
# _warn_missing <command> <error_context>
#
# Warning: <command> not found; skipping <error_context>
_warn_count=0
_warn_suppressed=0
_warn_missing() {
    [[ $- == *i* ]] || return 0 # Only show warnings in interactive shells

    if ((_warn_count < 3)); then
        printf 'Warning: %s not found; skipping %s\n' "$1" "$2" >&2
        ((_warn_count++))
    else
        ((_warn_suppressed++))
    fi
}

_warn_missing_summary() {
    if ((_warn_suppressed > 0)); then
        printf 'Warning: %d additional missing tool warnings suppressed\n' "$_warn_suppressed" >&2
    fi
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

# Saftey first!
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I' # -I prompts once if removing more than 3 files or recursively

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Create a new directory and any necessary parent directories (verbose)
alias md='mkdir -pv'

# Create directory and enter it
#
# mkcd <directory>
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ls aliases
alias l='ls --color --group-directories-first'
alias l='ls -l --color --group-directories-first --human-readable'
alias ll='ls -la --color --group-directories-first --human-readable'
alias la='ls -a --color --group-directories-first'

_run_if_exists eza "l alias" alias l='eza -l --icons --group-directories-first'
_run_if_exists eza "ll alias" alias ll='eza -la --icons --group-directories-first'
_run_if_exists eza "la alias" alias la='eza -a --icons --group-directories-first'

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

# Pretty print the type of a command, showing the function or alias definition with bat
#
# ptype <command>
if _command_exists bat; then
    ptype() {
        local name="$1"

        if declare -f "$name" >/dev/null; then
            declare -f "$name" | bat --language=bash --style=plain
        elif alias "$name" >/dev/null 2>&1; then
            alias "$name" | bat --language=bash --style=plain
        else
            builtin type "$name"
        fi
    }
else
    _warn_missing bat "ptype function"
fi

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

# View errors from the current boot
alias error="journalctl -b -p err"

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
_run_if_exists eza "eza alias" alias ls='eza --icons --group-directories-first'
_run_if_exists eza "eza alias" alias tree='eza --tree'
_run_if_exists fd "fd alias" alias find='fd'
_run_if_exists fzf "fzf alias" alias fzfp='fzf --preview "bat --color=always --style=numbers {}"'
_run_if_exists rg "rg alias" alias grep='rg'

_run_if_exists powertop "ptop alias" alias ptop='powertop'
_run_if_exists fastfetch "ff alias" alias ff='fastfetch'
_run_if_exists systemctl-tui "sys alias" alias sys='systemctl-tui'
_run_if_exists lazygit "lg alias" alias lg='lazygit'

_run_if_exists zeditor "zed alias" alias zed='zeditor'
_run_if_exists zen-beta "zen alias" alias zen='zen-beta'

# ~/.bashrc unsets the helpers
