# Alacritty

## Install

Make symbol links.

For customizing config on each machine instead of hardcode values in this git repository, see [Customize](#customize) section.

### Linux

Run in nushell in `033-alacritty`:

```nushell
mkdir ~/.config/alacritty
ln -s $"($env.PWD)/alacritty.toml" $"($env.HOME)/.config/alacritty/alacritty.toml"
ln -s $"($env.PWD)/themes" $"($env.HOME)/.config/alacritty/themes"
ln -s $"($env.PWD)/custom" $"($env.HOME)/.config/alacritty/custom"
```

### Windows

Run in powershell:

```powershell
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\alacritty\alacritty.toml" -Target "absolute\path\to\repo\033-alacritty\alacritty.toml"
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\alacritty\themes" -Target "absolute\path\to\repo\033-alacritty\themes"
new-Item -ItemType SymbolicLink -Path "$env:APPDATA\alacritty\custom" -Target "absolute\path\to\repo\033-alacritty\custom"
```

## Customize

Save custom toml config files in the `custom` directory to apply different custom config values on every machine.

In the [Install](#install) section, we symbol linked the `custom` directory into alacritty config directory.

Now we can use `custom/custom.toml` to define configs that vary between all machines we use.

Note that we use the import section in `alacritty.toml` which imports config from `custom/custom.toml`:

```toml
[general]
ipc_socket = false
import = ["custom/custom.toml"]
```

So in `custom/custom.toml`, we can write different config values on each machine:

```toml
[general]
import = ["../themes/catppuccin-mocha.toml"]

[font.normal]
family = "Iosevka1204 Nerd Font Mono"
style = "Regular"

[font.bold]
family = "Iosevka1204 Nerd Font Mono"
style = "Bold"

[font.italic]
family = "Iosevka1204 Nerd Font Mono"
style = "Italic"

[font.bold_italic]
family = "Iosevka1204 Nerd Font Mono"
style = "Bold Italic"
```
