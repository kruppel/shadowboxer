# MacOS

## Fix insecure zsh directories

```
$ compaudit | xargs chmod g-w
```

## Speed up cursor

```
$ defaults write NSGlobalDomain KeyRepeat -int 0
```

## Hostname

```
$ sudo scutil –-set HostName <hostname
```
