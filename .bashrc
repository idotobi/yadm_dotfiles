#
# ~/.bashrc
#

# vim mode
set -o vi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

export EDITOR=nvim
export VISUAL=nvim
function dgit {
  git --git-dir=${HOME}/.dotfiles_git/ --work-tree=${HOME} "$@"
}

export PS1='\[\033[32m\][\u@\h]:\[\033[01;34m\]$(echo "$(dirname "\w")"|sed -e "s;\(/.\)[^/]*;\1;g")/$(basename "$PWD") $\[\033[00m\] '

# automatically time every command
# https://stackoverflow.com/a/1862762
function timer_start {
  timer=${timer:-$SECONDS}
}

function timer_stop {
  timer_show=$((SECONDS - timer))
  unset timer
}

trap 'timer_start' DEBUG

# log all the commands not run as root
## https://spin.atomicobject.com/2016/05/28/log-bash-history/
function log_line {
  if [ ! -d ".logs" ]
  then
    mkdir .logs
  fi
  if [ "$(id -u)" -eq 0 ]; then
    exit 1
  fi
  command_date=$(date "+%Y-%m-%d.%H:%M:%S")
  history_line="$(history 1 | cut -d " " -f5-)"

  line="$command_date [${timer_show}s]:$(pwd) \$ $history_line"
  echo "$line" >> "${HOME}/.logs/bash-history-$(date "+%Y-%m-%d").log"
}

export PROMPT_COMMAND='timer_stop; log_line'

export PATH=$PATH:~/bin:~/.local/bin:~/scripts

if [ -f /usr/share/bash-completion/bash_completion ]; then
 source /usr/share/bash-completion/bash_completion
fi

function vim {
  nvim "$@"
}

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Always list all files except those in ~/.rgignore
# export FZF_DEFAULT_COMMAND='rg --files  --no-ignore-vcs --hidden'
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--preview="
  if [[ -d {} ]]; then
    exa -lahF --color=always {}
  else
    bat --style=numbers --color=always {} | head -100
  fi
"'
if [ -f /usr/share/fzf/key-bindings.bash ]; then
  source /usr/share/fzf/key-bindings.bash
fi
if [ -f /usr/share/fzf/completion.bash ]; then
  source /usr/share/fzf/completion.bash
fi


# Import the nix profile Environment Variables if nix is installed for the user
nix-pill() { source "$HOME/.nix-profile/etc/profile.d/nix.sh"; }

svn-repair() { mv -n -- "$2" "$1" && svn mv -- "$1" "$2"; }

complete -W "$(ls $HOME/.virtualenvironment)" -- vact
vact() { source "$HOME/.virtualenvironment/$1/bin/activate"; }

# Exercism
function bats-all {
  BATS_RUN_SKIPPED=true bats ./*_test.sh
}

# activate the fuck 
# https://github.com/nvbn/thefuck
eval $(thefuck --alias)

# Set ccache as default
export PATH="/usr/lib/ccache/bin/:$PATH"


quotes_script="~/scripts/quote_of_the_day.py"
if [ -d $quotes_script ]
then
  python ~/scripts/quote_of_the_day.py
fi
