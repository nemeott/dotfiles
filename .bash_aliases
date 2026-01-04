# Set alias only if the command exists
_alias_if() {
    # _alias_if <alias_name> <required_command> [alias_value...]
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

_alias_if cat bat bat
_alias_if man batman batman
_alias_if ls eza eza
# _alias_if ls eza eza --group-directories-first
_alias_if find fd fd
_alias_if fzfp fzf 'fzf --preview "bat --color=always --style=numbers {}"' # Start fzf with bat preview
_alias_if grep rg rg

unset -f _alias_if
