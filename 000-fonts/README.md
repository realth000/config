# Fonts
## Iosevka0828
Iosevka custom fonts with slab serifs.
### Build
* See how Iosevka0828 looks like:
  - Import config file iosevka-slab-ss08-0828.toml on [Iosevka Customizer](https://typeof.net/Iosevka/customizer).
1. Copy contents in iosevka-slab-ss08-0828.toml to private-build-plans.toml file in the Iosevka git repo.
2. Start build:
  * run `npm run build -- contents::iosevka0828` for TTF and Web fonts.
  * run `npm run build -- ttf::iosevka0828` for TTF fonts.
## Patch fonts to Nerd Fonts
* Use font patcher from [nerd fonts](https://github.com/ryanoasis/nerd-fonts/):

  ``` bash
  # CAUTION: CPU usage 100%
  for f in `find iosevka0828_20230729 -type f`; do ./fontpatcher/font-patcher $f --complete --quiet --mono --makegroups --outputdir ./iosevka0828NF_mono_groups_v3 &; done; wait
  ```

### Compatibility

Compatibility with Iosevka 25.1.1
  
## Iosevka1204
Iosevka custom fonts with sans serifs and little tails.
* See how Iosevka1204 looks like:
  - Import config file iosevka-sans-default-1204.toml on [Iosevka Customizer](https://typeof.net/Iosevka/customizer).
1. Copy contents in iosevka-sans-default-1204.toml to private-build-plans.toml file in the Iosevka git repo.
2. Start build:
  * run `npm run build -- contents::iosevka1204` for TTF and Web fonts.
  * run `npm run build -- ttf::iosevka1204` for TTF fonts.
## Patch fonts to Nerd Fonts
* Use font patcher from [nerd fonts](https://github.com/ryanoasis/nerd-fonts/):

  ``` bash
  # CAUTION: CPU usage 100%
  for f in `find iosevka1204 -type f`; do ./fontpatcher/font-patcher $f --complete --quiet --mono --makegroups --outputdir ./iosevka1204NF_mono_groups; done
  ```

  

