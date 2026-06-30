# Setup env.

# The internal logging function.
def env_log [message: string] {
    print $"(ansi yellow)env.nu: ($message)(ansi reset)"
}

$env.PATH = (
    $env.PATH | split row (char esep) | append ($env.HOME | path join .cargo bin) | append ($env.HOME | path join .local bin) | append ($nu.default-config-dir | path join bin)
)

# Configure starship.
if (echo ~/.cache/starship/init.nu | path exists) { use ~/.cache/starship/init.nu } else { env_log "startip not found, skip" }

# Command alias.

alias cw = if $nu.os-info.name == "windows" {  cd c:/Programming/Projects } else { cd ($env.HOME | path join "Programming") }
alias c = clear
alias dc = cd
alias t = tree
alias tl = tree | less

# Plugin alias

## fp

alias other = fp other
alias first-where = fp first-where
alias is = fp is
alias pure = fp pure
alias then = fp then
alias handle = fp handle
if (plugin list | where $it.name == "functional" | is-empty) {
    env_log "functional plugin not found, alias not added"
}

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

# Import custom alias.
# ref: https://github.com/nushell/nushell/discussions/16679#discussioncomment-14391728
const alias_mod_path = [$nu.default-config-dir, "custom", "custom_alias.nu"] | path join
const alias_mod = if ($alias_mod_path | path exists) { $alias_mod_path }
use $alias_mod *

# Import Custom envs.

# "$NU_CONFIG_DIR/custom/custom_env.nu"
#
# Refer to custom.md for example.
const env_mod_path = [$nu.default-config-dir, "custom", "custom_env.nu"] | path join
const have_env_mod = $env_mod_path | path exists
const env_mod = if $have_env_mod { $env_mod_path }
use $env_mod define_custom_env
if $have_env_mod {
    define_custom_env | load-env
} else {
    env_log "custom_env.nu not found, some envs not loaded.\nPlease make sure $nu.default-config-dir/custom/custom_env.nu exists."
}

# Import custom paths.
#
# All values returns in `define_custom_path` will be added to `$env.PATH`
const custom_mod_path = [$nu.default-config-dir, "custom", "custom_path.nu"] | path join
const have_path_mod = $custom_mod_path | path exists
const path_mod = if $have_path_mod { $custom_mod_path }
use $path_mod define_custom_path
if $have_path_mod {
    $env.PATH = ($env.PATH | split row (char esep) | append (define_custom_path))
}

if ($nu.os-info.name | str downcase) =~ windows and "NU_IN_WEZTERM" in $env and $env.NU_IN_WEZTERM == "true" {
    # Fix buffer scolling up issue when using with wezterm on windows.
    # https://github.com/wezterm/wezterm/discussions/5859#discussioncomment-13981942
    $env.config.shell_integration.osc133 = false
}
