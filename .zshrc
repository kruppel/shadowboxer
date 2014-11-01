. ~/.aliases

[[ -h $HOME/bin/z.sh ]] && source $HOME/bin/z.sh

export PATH=$HOME/bin:$PATH
export N_PREFIX=$HOME

SSH_KEY_FILE=$HOME/.ssh/id_rsa
[[ -z $(ssh-add -L | grep $SSH_KEY_FILE) ]] && ssh-add $SSH_KEY_FILE
