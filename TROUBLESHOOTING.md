# Stow

## Re-link dotfiles

After pulling changes, restow the affected packages (or just run `./setup`):

```
stow --target=$HOME --restow <package>
```

## A tool replaced a dotfile symlink with a plain file

Tools that rewrite configs atomically (`git config --global`, `gh auth setup-git`)
replace the symlink with a plain file. Remove the file and restow the package:

```
rm ~/.gitconfig && stow --target=$HOME --restow git
```

# MacOS

## Fix insecure zsh directories

```
compaudit | xargs chmod g-w
```

## Speed up cursor

```
defaults write NSGlobalDomain KeyRepeat -int 0
```

## Hostname

```
sudo scutil –-set HostName <hostname
```
