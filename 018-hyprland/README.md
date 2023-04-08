# What is Hyprland

[Hyprland](https://github.com/hyprwm/Hyprland) is a wayland compositor that supports much customization and runs fast.

# Install hyprland in arch

## Install basic system

Install using `archinstall`.

When install add `git` and `neovim` as additional packages.

During install, if the following error occurs:

> AttributeError: 'NoneType' object has no attribute 'encryption password'

Modify `/usr/lib/python3.10/site-packages/archinstall/lib/configuration.py` at line 74 according to [github issue](https://github.com/archlinux/archinstall/issues/1715):

``` diff
- if key == 'disk_encryption':
+ if key == 'disk_encryption' and self._config[key]:
```

## Follow tutorial to install hyprland

Suggest to follow [youtube v2 tutorial](https://www.youtube.com/watch?v=8GmpCwBqHCA&ab_channel=SolDoesTech).

But in this file I used the [v1 version tutorial](https://www.youtube.com/watch?v=lfUWwZqzHmA&t=6s&ab_channel=SolDoesTech).

Similar errors may occur after installation.

# Customize

## Basic customization

`Preparation`: have font `Iosevka1204Extended NF` built from `000-fonts`.

1. Clone the repo [realth000/config](https://github.com/realth000/config.git).
2. Copy `Iosevka1204Extended NF` fonts to `/usr/share/fonts/` and run `sudo fc-cache -f`.
3. Install `zsh` by `pacman -S zsh`.
4. Install zsh themes by running scripts in `002-zsh-install`.
5. Install `oh-my-posh` following README.md in `015-oh-my-posh`.
6. Install `neovim` plugins:

  1. Install [packer](https://github.com/wbthomason/packer.nvim) by `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim`.
  2. Copy files and folders in `014-nvim` to `~/.config/nvim`.
  3. Run `nvim`, run `:PackerInstall` to install part of configured plugins.
  4. Repeate step 3 several time untial all plugins installed.


## kitty

`kitty` is the default terminal installed from tutorial above.

> Since [wezterm](https://wezfurlong.org/wezterm/) has bad shading in wayland + nvidia, use kitty instead.

Update font in `~/.config/kitty/kitty.conf`:

``` diff
-font_family      firacode nerd font
+font_family      Iosevka1204Extended NF
```

## waybar

`waybar` is the top bar in screen.

Edit `~/.config/waybar/config.jsonc`:

Update `clock` value to this:

``` json
"format": "{:   %y-%m-%d   %H:%M:%S}",
"tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
"interval": 1
```

1. Add date and second to clock.
2. Refresh clock every 1 second.

Comment `interface` in `network`:

``` json
// "interface": "wlp2*", // (Optional) To force the use of this interface
```

Update `format-ethernet` in `network` to this:

``` json
"format-ethernet": "{bandwidthDownBits}/{bandwidthUpBits} ",
"interval": 1
```

1. Add upload/download rate.
2. Remove ip address.
3. Refresh network load rate every 1 second.


## Install nvidia driver

Suggest follow tutorial [here](https://wiki.hyprland.org/Nvidia/).

I'm using GTX 1050Ti, `pacman -S nvidia-dkms nvidia-settings nvidia-utils nvidia-vaapi-driver-git`.

Beside the tutorial above, makesure add nvidia modeset flags to grub:

1. Edit `/etc/default/grub`: add `nvidia_drm.modeset=1` to GRUB_CMDLINE_LINUX_DEFAULT and makegrub.
2. Add `options nvidia-drm modeset=1` to `/etc/modprobe.d/nvidia.conf`.
3. Add `nvidia nvidia_modeset nvidia_uvm nvidia_drm` to **MODULES** in `/etc/mkinitcpio.conf` to update initramfs every time drivers update.
4. Add following lines to `~/.config/hypr/hyprland.conf`:

``` bash
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1
env = WLR_EGL_NO_MODIFIRES,1
```

Without `WLR_NO_HARDWARE_CURSORS,1`, cursor may disappear once moved.

## Install fcitx to input Chinese

`yay -S fcitx5 fcitx5-breeze fcitx5-chinese-addons fcitx5-configtool fcitx5-gtk fcitx5-pinyin-sougou fcitx5-pinyin-zhwiki fcitx5-qt`.

Run `fcitx5-config-qt` adn set Chinese input method, also breeze-dark theme.

Add following lines to `~/.config/hypr/hyprland.conf`:

``` bash
exec-once=fcitx5-remote -r
exec-once=fcitx5 -d --replace
exec-once=fcitx5-remote -r
```

Add following lines to `~/.pam_environment`:

``` bash
#GTK_IM_MODULE DEFAULT=fcitx
#QT_IM_MODULE  DEFAULT=fcitx
#XMODIFIERS    DEFAULT=\@im=fcitx
#SDL_IM_MODULE DEFAULT=fcitx
# Wayland compatibility
QT_QPA_PLATFORM         DEFAULT=wayland
CLUTTER_BACKEND         DEFAULT=wayland
SDL_VIDEODRIVER         DEFAULT=wayland
MOZ_ENABLE_WAYLAND      DEFAULT=1
MOZ_WEBRENDER           DEFAULT=1
XDG_SESSION_TYPE        DEFAULT=wayland
XDG_CURRENT_DESKTOP     DEFAULT=sway

# QT-related theming
QT_QPA_PLATFORMTHEME    DEFAULT=qt5ct

# FCITX input-related
#GLFW_IM_MODULE         DEFAULT=ibus
GLFW_IM_MODULE          DEFAULT=fcitx
GTK_IM_MODULE           DEFAULT=fcitx
INPUT_METHOD            DEFAULT=fcitx
XMODIFIERS              DEFAULT=@im=fcitx
IMSETTINGS_MODULE       DEFAULT=fcitx
QT_IM_MODULE            DEFAULT=fcitx
```

For chrome, add ``--enable-wayland-ime --gtk-version=4`` to chrome Exec desktop.

## Setup screenshot

1. `sudo pacman -S grim slurp`
2. `git clone https://github.com/hyprwm/contrib`, copy binary `grimblast` under PATH.
3. Copy `screenshot.sh` to PATH.
4. Add following key bindings to `~/.config/hypr/hyprland.conf`:

``` bash
bind = , Print, exec, ~/.config/hypr/screenshot.sh # take a screenshot
bind = SHIFT, Print, exec, ~/.config/hypr/screenshot.sh screen
bind = CTRL SHIFT, Print, exec, ~/.config/hypr/screenshot.sh all-screen
```

`PrintScreen` to select an area to save.
`Shift + PrintScreen` to save current monitor.
`Ctrl + Shift + PrintScreen` to save all monitors.

Pictures saved in `~/Pictures`.



