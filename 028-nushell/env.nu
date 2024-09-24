# Nushell Environment Config File
#
# version = "0.96.1"

def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

$env.EDITOR = "nvim"

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

$env.NVIM_CUSTOM_COLORSCHEME = 'catppuccin-mocha'

use ~/.cache/starship/init.nu

alias cw = cd c:\Programming\Projects
alias c = clear

# Alias from oh-my-zsh https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
#alias grt = cd "$(git rev-parse --show-toplevel || echo .)"
#alias ggpur = ggu
alias g = git
alias ga = git add
alias gaa = git add --all
alias gapa = git add --patch
alias gau = git add --update
alias gav = git add --verbose
#alias gwip = git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"
alias gam = git am
alias gama = git am --abort
alias gamc = git am --continue
alias gamscp = git am --show-current-patch
alias gams = git am --skip
alias gap = git apply
alias gapt = git apply --3way
alias gbs = git bisect
alias gbsb = git bisect bad
alias gbsg = git bisect good
alias gbsn = git bisect new
alias gbso = git bisect old
alias gbsr = git bisect reset
alias gbss = git bisect start
alias gbl = git blame -w
alias gb = git branch
alias gba = git branch --all
alias gbd = git branch --delete
alias gbD = git branch --delete --force
#alias gbgd = LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '"'"'{print $1}'"'"' | xargs git branch -d
#alias gbgD = LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '"'"'{print $1}'"'"' | xargs git branch -D
alias gbm = git branch --move
alias gbnm = git branch --no-merged
alias gbr = git branch --remote
#alias ggsup = git branch --set-upstream-to=origin/$(git_current_branch)
#alias gbg = LANG=C git branch -vv | grep ": gone\]"
alias gco = git checkout
alias gcor = git checkout --recurse-submodules
alias gcb = git checkout -b
alias gcB = git checkout -B
#alias gcd = git checkout $(git_develop_branch)
#alias gcm = git checkout $(git_main_branch)
alias gcp = git cherry-pick
alias gcpa = git cherry-pick --abort
alias gcpc = git cherry-pick --continue
alias gclean = git clean --interactive -d
alias gcl = git clone --recurse-submodules
#alias gclf = git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules
alias gcam = git commit --all --message
alias gcas = git commit --all --signoff
alias gcasm = git commit --all --signoff --message
alias gcs = git commit --gpg-sign
alias gcss = git commit --gpg-sign --signoff
alias gcssm = git commit --gpg-sign --signoff --message
alias gcmsg = git commit --message
alias gcsm = git commit --signoff --message
alias gc = git commit --verbose
alias gca = git commit --verbose --all
alias gca! = git commit --verbose --all --amend
alias gcan! = git commit --verbose --all --no-edit --amend
alias gcans! = git commit --verbose --all --signoff --no-edit --amend
alias gcann! = git commit --verbose --all --date=now --no-edit --amend
alias gc! = git commit --verbose --amend
alias gcn! = git commit --verbose --no-edit --amend
alias gcf = git config --list
#alias gdct = git describe --tags $(git rev-list --tags --max-count=1)
alias gd = git diff
alias gdca = git diff --cached
alias gdcw = git diff --cached --word-diff
alias gds = git diff --staged
alias gdw = git diff --word-diff
alias gdup = git diff @{upstream}
alias gdt = git diff-tree --no-commit-id --name-only -r
alias gf = git fetch
alias gfo = git fetch origin
alias gg = git gui citool
alias gga = git gui citool --amend
alias ghh = git help
alias glgg = git log --graph
alias glgga = git log --graph --decorate --all
alias glgm = git log --graph --max-count=10
alias glods = git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short
alias glod = git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"
alias glola = git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all
alias glols = git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat
alias glol = git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"
alias glo = git log --oneline --decorate
alias glog = git log --oneline --decorate --graph
alias gloga = git log --oneline --decorate --graph --all
alias glp = _git_log_prettily
alias glg = git log --stat
alias glgp = git log --stat --patch
#alias gignored = git ls-files -v | grep "^[[:lower:]]"
#alias gfg = git ls-files | grep
alias gm = git merge
alias gma = git merge --abort
alias gmc = git merge --continue
alias gms = git merge --squash
alias gmff = git merge --ff-only
alias gmom = git merge origin/$(git_main_branch)
alias gmum = git merge upstream/$(git_main_branch)
alias gmtl = git mergetool --no-prompt
alias gmtlvim = git mergetool --no-prompt --tool=vimdiff
alias gl = git pull
alias gpr = git pull --rebase
alias gprv = git pull --rebase -v
alias gpra = git pull --rebase --autostash
alias gprav = git pull --rebase --autostash -v
#alias gprom = git pull --rebase origin $(git_main_branch)
#alias gpromi = git pull --rebase=interactive origin $(git_main_branch)
#alias gprum = git pull --rebase upstream $(git_main_branch)
#alias gprumi = git pull --rebase=interactive upstream $(git_main_branch)
#alias ggpull = git pull origin "$(git_current_branch)"
#alias gluc = git pull upstream $(git_current_branch)
#alias glum = git pull upstream $(git_main_branch)
alias gp = git push
alias gpd = git push --dry-run
alias gpf! = git push --force
#alias gpsup = git push --set-upstream origin $(git_current_branch)
alias gpv = git push --verbose
alias gpoat = git push origin --all and git push origin --tags
alias gpod = git push origin --delete
#alias ggpush = git push origin "$(git_current_branch)"
alias gpu = git push upstream
alias grb = git rebase
alias grba = git rebase --abort
alias grbc = git rebase --continue
alias grbi = git rebase --interactive
alias grbo = git rebase --onto
alias grbs = git rebase --skip
#alias grbd = git rebase $(git_develop_branch)
#alias grbm = git rebase $(git_main_branch)
alias grbom = git rebase origin/$(git_main_branch)
alias grbum = git rebase upstream/$(git_main_branch)
alias grf = git reflog
alias gr = git remote
alias grv = git remote --verbose
alias gra = git remote add
alias grrm = git remote remove
alias grmv = git remote rename
alias grset = git remote set-url
alias grup = git remote update
alias grh = git reset
alias gru = git reset --
alias grhh = git reset --hard
alias grhk = git reset --keep
alias grhs = git reset --soft
alias gpristine = git reset --hard and git clean --force -dfx
alias gwipe = git reset --hard and git clean --force -df
alias groh = git reset origin/$(git_current_branch) --hard
alias grs = git restore
alias grss = git restore --source
alias grst = git restore --staged
#alias gunwip = git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" and git reset HEAD~1
alias grev = git revert
alias greva = git revert --abort
alias grevc = git revert --continue
alias grm = git rm
alias grmc = git rm --cached
alias gcount = git shortlog --summary --numbered
alias gsh = git show
alias gsps = git show --pretty=short --show-signature
alias gstall = git stash --all
alias gstaa = git stash apply
alias gstc = git stash clear
alias gstd = git stash drop
alias gstl = git stash list
alias gstp = git stash pop
alias gsts = git stash show --patch
alias gst = git status
alias gss = git status --short
alias gsb = git status --short --branch
alias gsi = git submodule init
alias gsu = git submodule update
alias gsd = git svn dcommit
#alias git-svn-dcommit-push = git svn dcommit and git push github $(git_main_branch):svntrunk
alias gsr = git svn rebase
alias gsw = git switch
alias gswc = git switch --create
#alias gswd = git switch $(git_develop_branch)
#alias gswm = git switch $(git_main_branch)
alias gta = git tag --annotate
alias gts = git tag --sign
#alias gtv = git tag | sort -V
alias gignore = git update-index --assume-unchanged
alias gunignore = git update-index --no-assume-unchanged
alias gwch = git whatchanged -p --abbrev-commit --pretty=medium
alias gwt = git worktree
alias gwta = git worktree add
alias gwtls = git worktree list
alias gwtmv = git worktree move
alias gwtrm = git worktree remove
alias gstu = gsta --include-untracked
##alias gtl = gtl(){ git tag --sort=-v:refname -n --list "${1}*" }; noglob gtl
#alias gk = \gitk --all --branches &!
#alias gke = \gitk --all $(git log --walk-reflogs --pretty=%h) &!

