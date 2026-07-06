# Alacritty

## Install

Make symbol links.

### Linux

Run in nushell in `033-alacritty`:

```nushell
mkdir ~/.config/alacritty
ln -s $"($env.PWD)/alacritty.toml" $"($env.HOME)/.config/alacritty/alacritty.toml"
ln -s $"($env.PWD)/themes" $"($env.HOME)/.config/alacritty/themes"
```

### Windows

Run in powershell:

```powershell
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\alacritty\alacritty.toml" -Target "absolute\path\to\repo\033-alacritty\alacritty.toml"
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\alacritty\themes" -Target "absolute\path\to\repo\033-alacritty\themes"
```
