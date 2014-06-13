if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

. ~/.aliases

[[ -h $HOME/bin/z.sh ]] && source $HOME/bin/z.sh

prompt peepcode ❯
