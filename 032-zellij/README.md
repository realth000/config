# Zellij

## Install config

Symbol link the config here to the default config directory.

- On linux, it's `$HOME/.config/zellij`.
- On windows, it's `$env.APPDATA/Zellij/config`.

### Windows

To create symbol link on windows, enter the repo root where is the parent of 032-zellij directory and run:

```nushell
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\Zellij\config\config.kdl" -Target ".\032-zellij\config.kdl"
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\Zellij\config\default_layout.kdl" -Target ".\032-zellij\default_layout.kdl"
```

## Plugins

This config uses zellij plugins:

- [dj95/zjstatus](https://github.com/dj95/zjstatus/).
