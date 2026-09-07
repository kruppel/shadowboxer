# Stow

## Required version

`setup` requires GNU Stow 2.4.0 or newer. Check with `stow --version`.
Stow 2.3.1 prints repeated `BUG in find_stowed_path? Absolute/relative mismatch`
warnings when restowing beside unrelated absolute symlinks such as `~/dev -> /srv/dev`.
The warnings are harmless, but [Stow 2.4.0 fixes the bug](https://lists.gnu.org/archive/html/info-gnu/2024-04/msg00000.html).

Upgrade Stow using your package manager. If it only provides an older release,
install 2.4.1 from the [GNU release archive](https://ftp.gnu.org/gnu/stow/)
with Perl and Make installed:

```bash
build_dir=$(mktemp -d)
curl -fsSL https://ftp.gnu.org/gnu/stow/stow-2.4.1.tar.gz -o "$build_dir/stow.tar.gz"
tar -xzf "$build_dir/stow.tar.gz" -C "$build_dir"
(
  cd "$build_dir/stow-2.4.1" &&
    ./configure --prefix="$HOME/.local" &&
    make install
)
export PATH="$HOME/.local/bin:$PATH"
stow --version
```

Keep `~/.local/bin` ahead of system directories in your shell's `PATH`, then
rerun `./setup`.

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
