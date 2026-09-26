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

# Neovim clipboard and terminal links

Neovim uses LazyVim's existing `unnamedplus` behavior locally, so ordinary yanks
use the native system clipboard provider. Over SSH, the config keeps that behavior
and selects Neovim's built-in OSC 52 provider only when no native clipboard
provider is available. OSC 52 copying is generally reliable; clipboard reads
(pasting into Neovim) depend on the terminal accepting OSC 52 queries. Terminal
paste shortcuts remain a separate path.

The local terminal documented by this repository is Ghostty. It supports OSC 52
and OSC 8 links. Its default OSC 52 read policy may ask before allowing clipboard
reads. No terminal-specific setting is required for this configuration.

Emit an OSC 8 link in a shell to check the terminal path:

```sh
printf '\033]8;;https://example.com\033\\Example link\033]8;;\033\\\n'
```

Click `Example link` directly in Ghostty, then run the same command in an SSH
shell. This repository also tracks `config/.config/herdr/config.toml`, but that
file only configures Herdr keybindings and appearance; Herdr's pane terminal
behavior belongs to the separately installed Herdr application. Current Herdr
versions handle OSC 8 links inside panes with Ctrl-click. If direct and SSH links
work but the link fails only inside Herdr, check/update the Herdr client: that
layer parses pane OSC 8 metadata and handles the click. There is no OSC 8
passthrough setting in this repository's Herdr config. The same boundary applies
to OSC 52 clipboard writes: if yanks work over plain SSH but not from a Herdr
pane, the Herdr session client must forward those writes to the local terminal.

Manual checks:

1. Locally, yank text with `yy` and paste it into another application. `"+y` and
   `"*y` remain available for explicit clipboard registers.
2. Over SSH, use `yy` and paste into a local application. This sends an OSC 52
   clipboard write through the terminal/session layer. Also check `"+y` and
   `"*y` if you use explicit clipboard registers.
3. In a local Ghostty shell, run the OSC 8 command above and click `Example link`.
4. Run the OSC 8 command in a plain SSH shell and click `Example link` in the
   local terminal.
5. Run the OSC 8 command in a Herdr pane and Ctrl-click the visible link. Herdr's
   own client must support pane OSC 8 links; `TMUX` being empty means tmux is not
   part of the reported route.
