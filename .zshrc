. ~/.aliases

# chruby auto-switching
. /usr/local/share/chruby/chruby.sh
. /usr/local/share/chruby/auto.sh

[[ -h $HOME/bin/z.sh ]] && source $HOME/bin/z.sh

SSH_KEY_FILE=$HOME/.ssh/id_rsa
if [[ -a SSH_KEY_FILE && -z $(ssh-add -L | grep $SSH_KEY_FILE) ]]
then
  ssh-add $SSH_KEY_FILE
fi

autoload -U myprompt_init
myprompt_init

bindkey -e

HISTFILE=~/.zsh/history
setopt SHARE_HISTORY
