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

fpath=($HOME/.zsh/site-functions $fpath)

setopt PROMPTSUBST
autoload -Uz myprompt_init
myprompt_init

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

set -o vi

# Autoload compinit for autocompletion
autoload -Uz compinit

if [[ -s /usr/local/share/zsh-completions ]]
then
  fpath=($HOME/.zsh/site-functions /usr/local/share/zsh-completions $fpath)
fi

if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]
then
  compinit
else
  compinit -C
fi

# enabling recursive search
# ref: http://chneukirchen.org/blog/archive/2013/03/10-fresh-zsh-tricks-you-may-not-know.html
autoload -Uz narrow-to-region
function _history-incremental-preserving-pattern-search-backward
{
  local state
  MARK=CURSOR
  narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
  zle end-of-history
  zle history-incremental-pattern-search-backward
  narrow-to-region -R state
}
zle -N _history-incremental-preserving-pattern-search-backward
bindkey "^R" _history-incremental-preserving-pattern-search-backward
bindkey -M isearch "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

. ~/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
