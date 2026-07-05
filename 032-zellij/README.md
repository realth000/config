# Zellij

## Contents

- Zellij config and layouts are stored in the `config` directory.
- Plugin files are saved in the `data` directory.

## Install config

Zellij supports loading layout files and plugins files from a relative file path, as long as those files are stored in **the default directory**:

- On linux, it's `$HOME/.config/zellij`.
  - `$HOME/.config/zellij/config/config.kdl` for config file.
  - `$HOME/.config/zellij/config/layouts` directory for layout files.
  - `$HOME/.config/zellij/data/plugins` directory for plugin files.
- On windows, it's `$env.APPDATA/Zellij`.
  - `$env:APPDATA/Zellij/config/config.kdl` for config file.
  - `$env:APPDATA/Zellij/config/layouts` directory for layout files.
  - `$env:APPDATA/Zellij/data/plugins` directory for plugin files.

> To check default directories, run `zellij setup --check`.

This repository already saves config files and plugin files in the same structure:

- Config file at `config/config.kdl`.
- Layout files in `config/layouts` directory.
- Plugin files in `data/plugins` directory.

Symbol link the `config` directory and `data` directory here to the default zellij directory, all configs and plugin files will be installed.

### Windows platform

To create symbol link on windows, run `new-Item` command in powershell:

```powershell
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\Zellij\config" -Target "absolute\path\to\repo\032-zellij\config"
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\Zellij\data" -Target "absolute\path\to\repo\032-zellij\data"
```

links config directories to zellij default directory.

## Layout

For a layout file called `default_layout.kdl` in the `layouts` directory, run `zellij --layout default_layout` to load it.

## Plugins

For a plugin file named `zjstatus.wasm` in the `data/plugins` directory, use `"file:zjstatus.wasm"` in config to load it.

Download plugin files (*.wasm) into `data/plugins` directory.

If you followed previous install steps, plugins are already loaded.

Plugins used in config:

- [dj95/zjstatus](https://github.com/dj95/zjstatus/).
