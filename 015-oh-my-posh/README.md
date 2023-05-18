#  Oh My Posh

## Install

### With zsh

``` bash sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
```

* Apply to zsh

Use ``zshrc`` in this folder or:

Add the following line to **the tail of** ``~/.zshrc``:

``` bash
eval "$(oh-my-posh init zsh)"
```

If using powerlevel10k, recommand following steps:

1. Add ``CUSTOM_USE_OH_MY_POSH=true``.
2. Add the following ``if``:
``` bash
if [[ ! ${CUSTOM_USE_OH_MY_POSH} ]];then
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi
```
3. Add the following line to **the tail of** ``~/.zshrc``:
``` bash
if [[ ${CUSTOM_USE_OH_MY_POSH} ]];then
  eval "$(oh-my-posh init zsh)"
fi
```

### With MSYS2

Download windows amd64 oh-my-posh executable instead.

### With windows terminal

Download:

``` powershell
scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
```

Enable:

1. Open windows terminal and start powershell.
2. ``notepad $PROFILE`` and add the content in (profile1.ps)[./Microsoft.PowerShell_profile.ps1].
3. Restart terminal.

## Install themes

``` bash
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip
```

## Customize

Adjust the Oh My Posh init line in ~/.zshrc by adding the --config flag with the location of your configuration.

``` bash
eval "$(oh-my-posh init zsh --config ~/.poshthemes/jandedobbeleer.omp.json)"
```

Compare to powerlevel10k, oh-my-posh themes may need more ``transient_propmt`` config in json:

``` json
{
    "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
    "blocks": {
        ...
    },
    "transient_prompt": {
        "background": "transparent",
        "foreground": "#ffffff",
        "template": "{{ .Shell }}> "
    }
}
```

To disable update hints:

``` shell
oh-my-posh disable notice
```

## Symbols

273f: ✿
3744: ❄

