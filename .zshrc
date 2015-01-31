. ~/.aliases

# chruby auto-switching
if [[ -d /usr/local/share/chruby ]]
then
  . /usr/local/share/chruby/chruby.sh
  . /usr/local/share/chruby/auto.sh
fi

[[ -h $HOME/bin/z.sh ]] && source $HOME/bin/z.sh

SSH_KEY_FILE=$HOME/.ssh/id_rsa
if [[ -a SSH_KEY_FILE && -z $(ssh-add -L | grep $SSH_KEY_FILE) ]]
then
  ssh-add $SSH_KEY_FILE
fi

setopt PROMPTSUBST
autoload -Uz myprompt_init
myprompt_init

bindkey -e

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
