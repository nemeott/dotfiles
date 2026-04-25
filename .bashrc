# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#
# Smarter completion
#

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"

# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# Show all possible completions if not specific enough
bind 'set show-all-if-ambiguous on'

# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

# Prepend cd to directory names automatically
shopt -s autocd 2>/dev/null

# Correct spelling errors during tab-completion
shopt -s dirspell 2>/dev/null

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2>/dev/null

#
# History options
#

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# Avoid duplicate entries and lines starting with space
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:cd:ls:y:clear:bash:exit:history:reboot:\
    btop:ptop:ff:sys:lg:y"

#
# Prompt
#

# Chroot name (if any)
[ -r /etc/debian_chroot ] && debian_chroot=$(</etc/debian_chroot)

# Enable color if supported
case "$TERM" in
*-256color | alacritty | foot) color_prompt=yes ;;
esac

if [ "$color_prompt" = yes ]; then
    # Default prompt
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

    # Dynamic prompt function
    set_prompt() {
        local last_exit=$? # Capture exit status of last command for prompt symbol coloring

        # # Regular text colors
        # local BLACK='\[\e[0;30m\]'
        local RED='\[\e[0;31m\]'
        # local GREEN='\[\e[0;32m\]'
        # local YELLOW='\[\e[0;33m\]'
        # local BLUE='\[\e[0;34m\]'
        # local MAGENTA='\[\e[0;35m\]'
        # local CYAN='\[\e[0;36m\]'
        local WHITE='\[\e[0;37m\]'

        # Bold text colors
        # local BBLACK='\[\e[1;30m\]'
        local BRED='\[\e[1;31m\]'
        local BGREEN='\[\e[1;32m\]'
        local BYELLOW='\[\e[1;33m\]'
        local BBLUE='\[\e[1;34m\]'
        local BMAGENTA='\[\e[1;35m\]'
        local BCYAN='\[\e[1;36m\]'
        # local BWHITE='\[\e[1;37m\]'

        # # Background colors
        # local BGBLACK='\[\e[40m\]'
        # local BGRED='\[\e[41m\]'
        # local BGGREEN='\[\e[42m\]'
        # local BGYELLOW='\[\e[43m\]'
        # local BGBLUE='\[\e[44m\]'
        # local BGMAGENTA='\[\e[45m\]'
        # local BGCYAN='\[\e[46m\]'
        # local BGWHITE='\[\e[47m\]'

        local CHROOT='${debian_chroot:+'"$BMAGENTA"'($debian_chroot) '"$WHITE"'}'

        local NIX=""
        if [[ -n "$IN_NIX_SHELL" ]]; then
            if [[ -n "$NIX_SHELL_LEVEL" ]]; then
                NIX="$BBLUE(nix-shell:$NIX_SHELL_LEVEL)$WHITE "
            else
                NIX="$BBLUE(nix-shell)$WHITE "
            fi
        fi

        local CONDA=""
        if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
            CONDA="$BRED($CONDA_DEFAULT_ENV) $WHITE"
        fi

        local VENV=""
        if [[ -n "$VIRTUAL_ENV_PROMPT" ]]; then
            # Strip whitespace
            local v="${VIRTUAL_ENV_PROMPT//[[:space:]]/}"

            # Add parentheses if missing
            if [[ "$v" != \(*\) ]]; then
                v="($v)"
            fi

            # Formatted like "(venv_name) "
            VENV="$BMAGENTA$v "
        fi

        local USER="$BGREEN\u"
        local AT="$BMAGENTA@"
        local HOST="$BCYAN\h$WHITE"
        local DIRECTORY="$BYELLOW\w"

        # Red # for root
        # Red $ on failed command
        # White $ otherwise
        local symbol
        if [ "${EUID:-0}" -eq 0 ]; then
            symbol="$RED#$WHITE "
        elif [ "$last_exit" -eq 0 ]; then
            symbol="$WHITE\$ "
        else
            symbol="$RED\$ $WHITE"
        fi

        PS1="$CHROOT$NIX$CONDA$VENV$USER$AT$HOST:$DIRECTORY$symbol"
    }
    PROMPT_COMMAND='set_prompt'
else
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

#
# Path modifications
#
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

# Activate atuin if installed in home directory (ssh servers)
if [ -f "$HOME/.atuin/bin/env" ]; then
    source "$HOME/.atuin/bin/env"
fi

#
# Enable CLI tools enhancements
#

# Enable fzf
if _command_exists fzf; then
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
else
    _warn_missing fzf "fzf initialization"
fi

# Enable zoxide and replace cd (can also use cdi to search cd history)
_run_if_exists zoxide 'zoxide initialization\n\tInstall through package manager or with: curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh' \
    eval '$(zoxide init bash --cmd cd)'

# Enable batman (colored man pages)
_run_if_exists batman "batman initialization" \
    eval '$(batman --export-env)'

# Enable batpipe (colored less)
_run_if_exists batpipe "batpipe initialization" \
    eval '$(batpipe)'

# Enable atuin for better bash history (atuin needs bash-preexec)
if _command_exists atuin; then
    if [[ -f ~/.bash-preexec.sh ]]; then
        source ~/.bash-preexec.sh
        eval "$(atuin init bash)"
    else
        _warn_missing ~/.bash-preexec.sh 'atuin initialization\n\tInstall with: curl -fsSL https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh'
    fi
else
    _warn_missing atuin 'atuin initialization\n\tInstall through package manager or with: curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh'
fi

# Direnv integration
_run_if_exists direnv "direnv initialization" \
    eval '$(direnv hook bash)'

# Use yazi shell wrapper to enable changing cwd from yazi
if _command_exists yazi; then
    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d '' cwd <"$tmp"
        [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    }
else
    _warn_missing yazi "yazi shell wrapper function"
fi

#
# Cleanup
#

# Print suppressed warnings summary (if any)
_warn_missing_summary

unset -f _command_exists
unset -f _warn_missing
unset -f _warn_missing_summary
unset _warn_count
unset _warn_suppressed
unset -f _run_if_exists

#
# Editor
#

# Set Zed as default editor
export EDITOR="zeditor"
export VISUAL="zeditor"
export SUDO_EDITOR="zeditor --wait" # (sudoedit)
export GIT_EDITOR="zeditor --wait"
