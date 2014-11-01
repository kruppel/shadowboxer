. ~/.aliases

[[ -h $HOME/bin/z.sh ]] && source $HOME/bin/z.sh

export PATH=$HOME/bin:$PATH
export N_PREFIX=$HOME

SSH_KEY_FILE=$HOME/.ssh/id_rsa
if [[ -a SSH_KEY_FILE && -z $(ssh-add -L | grep $SSH_KEY_FILE) ]]
then
  ssh-add $SSH_KEY_FILE
fi
