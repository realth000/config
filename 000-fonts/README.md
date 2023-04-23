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
  for f in `find iosevka0828 -type f`; do ./nerd-fonts/font-patcher $f --complete --quiet --windows --mono --makegroups --outputdir ./iosevka0828NFM; done
  ```

  
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
  # Old double width style.
  #for f in `find iosevka1204 -type f`; do ./nerd-fonts/font-patcher $f --complete --quiet --windows --mono --makegroups --outputdir ./iosevka1204NFM; done

  #for f in `find iosevka1204 -type f`; do ./fontpathcer/font-patcher $f --complete --quiet --windows --mono --careful --outputdir ./iosevka1204NFM; done

  # Single width style.
  for f in `find iosevka1204 -type f`; do ./fontpathcer/font-patcher $f --complete --quiet --windows --outputdir ./iosevka1204NFM; done
  ```

  

