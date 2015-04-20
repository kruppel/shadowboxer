HISTFILE=~/.zsh/history
SAVEHIST=1000
HISTSIZE=1000

export PATH=$HOME/bin:./node_modules/.bin:$PATH
export MANPATH=$HOME/man:$MANPATH
export N_PREFIX=$HOME
export GOPATH=$HOME/.go

fpath=("$HOME/.zsh/site-functions" $fpath)
