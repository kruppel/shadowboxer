export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

export LC_ALL='en_US.UTF-8'

export HISTFILE=~/.zsh/history
export SAVEHIST=1000
export HISTSIZE=1000

export FZF_DEFAULT_COMMAND='rg --files --follow'
export MANPATH=$HOME/man:$MANPATH
export N_PREFIX=$HOME
export GOPATH=$HOME/.go
export _Z_NO_RESOLVE_SYMLINKS=1

export XDG_CONFIG_HOME=$HOME/.config
