#
# ~/.bashrc
#

# set -x

# vim mode
set -o vi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

export EDITOR=hx
export VISUAL=hx
function dgit {
  git --git-dir="${HOME}/.dotfiles_git/" --work-tree="${HOME}" "$@"
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

# optionally source File
function optional_source {
  source="$1"
  # shellcheck source=/dev/null
  [[ -s "$source" ]] && source "$source"
}

trap 'timer_start' DEBUG

# log all the commands not run as root
## https://spin.atomicobject.com/2016/05/28/log-bash-history/
log_dir="${HOME}/.logs"
function log_line {
  if [ ! -d "$log_dir" ]
  then
    mkdir "$log_dir"
  fi
  if [ "$(id -u)" -eq 0 ]; then
    exit 1
  fi
  command_date=$(date "+%Y-%m-%d.%H:%M:%S")
  history_line="$(history 1 | cut -d " " -f5-)"

  line="$command_date [${timer_show}s]:$(pwd) \$ $history_line"
  echo "$line" >> "${log_dir}/bash-history-$(date "+%Y-%m-%d").log"
}

export PROMPT_COMMAND='timer_stop; log_line'

export PATH=$PATH:~/bin:~/.local/bin:~/scripts:~/go/bin:~/.cargo/bin


optional_source /usr/share/bash-completion/bash_completion

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

optional_source /usr/share/fzf/key-bindings.bash
optional_source /usr/share/fzf/completion.bash


# Import the nix profile Environment Variables if nix is installed for the user
# shellcheck source=/dev/null
nix-pill() { source "$HOME/.nix-profile/etc/profile.d/nix.sh"; }

svn-repair() { mv -n -- "$2" "$1" && svn mv -- "$1" "$2"; }

venv_dir="$HOME/.virtualenvironment"
if [ -d "$venv_dir" ]
then
  complete -W "$(ls $venv_dir)" -- vact
  vact() { source "$venv_dir/$1/bin/activate"; }
fi

# Exercism
function bats-all {
  BATS_RUN_SKIPPED=true bats ./*_test.sh
}

# Set ccache as default
export PATH="/usr/lib/ccache/bin/:$PATH"


quotes_script="$HOME/scripts/quote_of_the_day.py"
if [ -d "$quotes_script" ]
then
  python ~/scripts/quote_of_the_day.py
fi

# starship
eval "$(starship init bash)"
# navi
eval "$(navi widget bash)"
optional_source "$HOME/.cargo/env"

# Enable gradlew autocompletion
# see https://github.com/gradle/gradle-completion
optional_source "$HOME/bash_completion.d/gradle-completion.bash"

# Source general completions
completions_folder="$HOME/.bash_completions"
if [ -d "$completions_folder" ]
then
  for f in "$completions_folder"/*.sh; do source "$f"; done;
fi


asdf_folder="$HOME/.asdf"
optional_source "$asdf_folder/asdf.sh"
optional_source "$asdf_folder/completions/asdf.bash"
# In case of AUR asdf installation
optional_source /opt/asdf-vm/asdf.sh

# Alias for Localstack usage
## aws default profile needs to be configured according to
## https://docs.localstack.cloud/integrations/aws-cli/#setting-up-local-region-and-credentials-to-run-localstack
alias awslocal="aws --endpoint-url=${LOCALSTACK_HOST:-http://localhost:4566}"
# enable bash-completion for awslocal alias
complete -C aws_completer awslocal
complete -C aws_completer aws

export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.bash ] && . "$HOME/.config/tabtab/__tabtab.bash" || true

export PATH="$HOME/.custom_bin:$PATH"
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
# Flutter
export PATH="$HOME/Documents/private/projects/alite/development/flutter/bin:$PATH"

# limit jest workers to 4 to mitigate OOM due to too many workers
alias npm="taskset -c 0-4 npm"
