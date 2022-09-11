## Git
### Use GPG key on Windows
From [here](https://www.liesauer.net/blog/post/sign-git-commit-with-gpg-under-windows.html)
1. Install Gpg4win from [Gpg4win Official Website](https://gpg4win.org/download.html)
  * During install, select to install the component Kleopatra.
2. Import GPG key or generate new gpg key in Kleopatra.
3. In git, set git ``config --global gpg.program`` value to path/to/
4. Enable global GPG signing: 
   ~~~ bash
   git config --global user.signingkey <key name>
   git config --global commit.gpgsign true
   git config --global gpg.program "path/to/GnuPG/bin/gpg.exe"
   ~~~
5. Set no password time:
   In Kleopatra, Settings => GnuPG System => Private Keys => Expire cached PINs after N seconds, set this to some time.
