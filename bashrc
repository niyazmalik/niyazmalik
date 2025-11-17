# ~/.bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings - increased for better history
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
shopt -s checkwinsize

# Color support for ls and grep
alias ls='ls --color=auto'
export LS_COLORS='di=1;34:ex=1;93:ow=34:tw=34'
alias grep='grep --color=auto'

# Faster, better aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'

# Skip bash completion (this can be slow, will enable it if only I need it)
# if ! shopt -oq posix; then
#   if [ -f /usr/share/bash-completion/bash_completion ]; then
#     . /usr/share/bash-completion/bash_completion
#   fi
# fi

# Faster cd (don't check for typos)
shopt -u cdspell 2>/dev/null

# Disable mail check
unset MAILCHECK

# Always start in Windows Desktop/nm folder
cd /mnt/c/Users/__nm/Desktop/ 2>/dev/null

# Quick C++ compile and run with optimization
run() {
  local src="${1:-run.cpp}"
  g++ -std=c++17 -O2 "$src" -o "${src%.cpp}" && "./${src%.cpp}"
}

out() {
  local src="${1:-run.cpp}"
  "./${src%.cpp}"
}

# Custom prompt!
PS1='\[\033[0;31m\]◆ Command!\[\033[0m\] '
