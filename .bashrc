# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
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
shopt -s autocd 2> /dev/null

# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

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
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

#
# Prompt
#

# Chroot name (if any)
[ -r /etc/debian_chroot ] && debian_chroot=$(< /etc/debian_chroot)

# Enable color if supported
case "$TERM" in
	*-256color|alacritty|foot) color_prompt=yes ;;
esac

if [ "$color_prompt" = yes ]; then
	# Default prompt
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

	# # Timing code from https://stackoverflow.com/a/34812608
 #    timer_now() {
	# 	date +%s%N
	# }

	# Dynamic prompt function
	set_prompt() {
	# 	local timer_show=""
	# 	if [[ -n "$timer_start" ]]; then
	# 	    local now=$(timer_now)
	# 	    local delta_us=$(( (now - timer_start) / 1000 ))

	# 	    local us=$((delta_us % 1000))
	# 	    local ms=$(((delta_us / 1000) % 1000))
	# 	    local s=$(((delta_us / 1000000) % 60))
	# 	    local m=$(((delta_us / 60000000) % 60))
	# 	    local h=$((delta_us / 3600000000))

	# 	    if ((h > 0)); then timer_show=${h}h${m}m
	# 	    elif ((m > 0)); then timer_show=${m}m${s}s
	# 	    elif ((s >= 10)); then timer_show=${s}.$((ms / 100))s
	# 	    elif ((s > 0)); then timer_show=${s}.$(printf %03d $ms)s
	# 	    elif ((ms >= 100)); then timer_show=${ms}ms
	# 	    elif ((ms > 0)); then timer_show=${ms}.$((us / 100))ms
	# 	    else timer_show=${us}us
	# 	    fi
	# 	fi

	#     local last_exit=$__LAST_EXIT

	    local last_exit=$?

		# # Regular text colors
		# local BLACK='\[\e[0;30m\]'
		local RED='\[\e[0;31m\]'
		# local GREEN='\[\e[0;32m\]'
		local YELLOW='\[\e[0;33m\]'
		# local BLUE='\[\e[0;34m\]'
		# local MAGENTA='\[\e[0;35m\]'
		# local CYAN='\[\e[0;36m\]'
		local WHITE='\[\e[0;37m\]'

		# Bold text colors
		# local BBLACK='\[\e[1;30m\]'
		# local BRED='\[\e[1;31m\]'
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
		    NIX="$BBLUE(nix-shell)$WHITE "
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
	    if [ "$UID" -eq 0 ]; then
	        symbol="$RED#$WHITE "
	    elif [ "$last_exit" -eq 0 ]; then
	        symbol="$WHITE\$ "
	    else
	        symbol="$RED\$ $WHITE"
	    fi

	    PS1="$CHROOT$NIX$VENV$USER$AT$HOST:$DIRECTORY$symbol"
	    # PS1="($timer_show) $VENV$CHROOT$USER$HOST:$DIRECTORY$symbol"
	}

	# trap 'timer_start=$(timer_now)' DEBUG
	# PROMPT_COMMAND='__LAST_EXIT=$?; set_prompt'
	PROMPT_COMMAND='set_prompt'
else
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
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

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

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
# Enable CLI tools enhancements
#

# Show a warning only in interactive shells
_warn_missing() {
  [[ $- == *i* ]] && printf 'Warning: %s not found; skipping %s\n' "$1" "$2" >&2
}

# Enable fzf
if command -v fzf >/dev/null 2>&1; then
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
else
    _warn_missing fzf "fzf initialization"
fi

# Enable zoxide and replace cd (can also use cdi to search cd history)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --cmd cd)"
else
    _warn_missing zoxide "zoxide initialization"
fi

# Enable batman (colored man pages)
if command -v batman >/dev/null 2>&1; then
    eval "$(batman --export-env)"
else
    _warn_missing batman "batman initialization"
fi

# Enable batpipe (colored less)
if command -v batpipe >/dev/null 2>&1; then
    eval "$(batpipe)"
else
    _warn_missing batpipe "batpipe initialization"
fi

# Enable atuin for better bash history (atuin needs bash-preexec)
if [[ -f ~/.bash-preexec.sh ]]; then
    if command -v atuin >/dev/null 2>&1; then
        source ~/.bash-preexec.sh
        eval "$(atuin init bash)"
    else
        _warn_missing atuin "atuin initialization"
    fi
else
    _warn_missing ~/.bash-preexec.sh $'atuin initialization\nInstall with: curl -fsSL https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh'
fi


# Direnv integration
if command -v direnv >/dev/null 2>&1; then
	eval "$(direnv hook bash)"
else
	_warn_missing direnv "direnv initialization"
fi


unset -f _warn_missing

# Set Zed as default editor
export EDITOR="zeditor"
export VISUAL="zeditor"
export SUDO_EDITOR="zeditor --wait" # (sudoedit)
export GIT_EDITOR="zeditor --wait"
