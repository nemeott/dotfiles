# Allow aliases to work with sudo
alias sudo='sudo '

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
        # If in interactive shell, print a warning
        [[ $- == *i* ]] && printf 'Warning: %s not found, skipping alias for %s\n' "$cmd" "$name" >&2
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

# Clipboard utilities
_alias_if cwd xclip 'pwd | xclip -selection clipboard' # Copy working directory to clipboard
if command -v xclip >/dev/null 2>&1; then
    cfp() {
        readlink -f "$1" | xclip -selection clipboard
    }
else
    printf 'Warning: xclip not found, skipping cfp alias\n' >&2
fi

unset -f _alias_if
