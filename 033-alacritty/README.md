# Alacritty

## Install

Make symbol links.

### Linux

Run in nushell:

```nushell
ln -s "/absolute/path/to/repo/033-alacritty/alacritty.toml" $"($env.HOME)/.config/alacritty/alacritty.toml"
ln -s "/absolute/path/to/repo/033-alacritty/themes" $"($env.HOME)/.config/alacritty/themes"
```

### Windows

Run in powershell:

```powershell
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\alacritty\alacritty.toml" -Target "absolute\path\to\repo\033-alacritty\alacritty.toml"
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\alacritty\themes" -Target "absolute\path\to\repo\033-alacritty\themes"
```
