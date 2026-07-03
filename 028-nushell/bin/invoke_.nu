# A wrapper command to run commands with a list of args.
#
# Sometimes we want to run a built-in command with a list of args:
#
# `ls [-l, -a, ...]`
#
# Why not directly call with args? Because the args may be dynamically populated:
#
# `mut args = []; if show_all_files { $args = $args | append '-a' }`
#
# Unfortunately, we can not invoke built-in commands with list of args, that is,
# `ls $args` not works.
# And spread operator only works for external commands: `^ls ...$args`.
#
# Then use the `invoke` command: `invoke ls [-l, -a]` or `invoke ls -l -a`.
#
# Note that `invoke` spawns a new nushell instance so:
#
# 1. Custom envs and variables in current nushell instance are not available.
# 2. Custom commands are not available.
@category wrapper
@example r#'Run built-in ls command with args "-l, -a"'# { invoke ls -l -a }
@example r#'Run external ls command with args "-l, -a"'# { invoke ^ls -l -a }
@example r#'Run built-in ls command with args "-l, -a" stored in variable'# { let args = [-l, -a]; invoke ls $args }
@example r#'Run external ls command with args "-l, -a" stored in variable'# { let args = [-l, -a]; invoke ^ls $args }
export def --wrapped invoke [
    command: string,
    ...args
    ] {
    nu --no-history -c $"($command) (echo ...$args | str join ' ') | to nuon" | from nuon
}
